import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'userlistitem.dart'; // Add import statement for UserListItem
import 'UserProfileDetails.dart'; // Add import statement for UserProfileDetails

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];
  int currentPage = 1;
  bool isLoading = false;
  bool reachedEnd = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RestAPI Data"),
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    if (users.isEmpty && isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (users.isEmpty) {
      return Center(
        child: Text('No data available.'),
      );
    } else {
      return ListView.builder(
        itemCount: users.length + (reachedEnd ? 0 : 1),
        itemBuilder: (context, index) {
          if (index < users.length) {
            final user = users[index];
            final picture =
                user['picture']['large']; // Accessing thumbnail picture
            final email = user['email'];
            final title = user['name']['title'];
            final first = user['name']['first'];
            final last = user['name']['last'];

            return UserListItem(
              email: email,
              thumbnail: picture,
              title: title,
              first: first,
              last: last,
              onTap: () {
                final user = users[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileDetails(
                      email: user['email'],
                      largePictureUrl: user['picture']['large'],
                      title: user['name']['title'],
                      firstName: user['name']['first'],
                      lastName: user['name']['last'],
                      streetNumber:
                          user['location']['street']['number'].toString(),
                      streetName: user['location']['street']['name'],
                      city: user['location']['city'],
                      state: user['location']['state'],
                      country: user['location']['country'],
                      postcode: user['location']['postcode'],
                      phone: user['phone'],
                      cell: user['cell'],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('Loading...'),
            );
          }
        },
        controller: _scrollController,
      );
    }
  }

  Future<void> fetchUsers() async {
    if (isLoading || reachedEnd) return;
    setState(() {
      isLoading = true;
    });

    final url = 'https://randomuser.me/api/?page=$currentPage&results=10';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          users.addAll(json['results']);
          isLoading = false;
          if (json['results'].isEmpty) {
            reachedEnd = true;
          } else {
            currentPage++;
          }
        });
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      fetchUsers();
    }
  }
}
