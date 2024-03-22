import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final String email;
  final String thumbnail;
  final String title;
  final String first;
  final String last;
  final VoidCallback onTap; // Define the onTap callback

  const UserListItem({
    Key? key,
    required this.email,
    required this.thumbnail,
    required this.title,
    required this.first,
    required this.last,
    required this.onTap, // Add onTap parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the provided onTap callback
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          tileColor: const Color.fromARGB(103, 255, 255, 255),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _showLargeImage(context), // Show large image on tap
                child: Hero(
                  tag: thumbnail,
                  child: Image.network(
                    thumbnail,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error); // Display error icon for failed image
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$title: $first $last'),
                    Text('Email: $email'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLargeImage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5), // Black with opacity
            body: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Hero(
                  tag: thumbnail,
                  child: Image.network(
                    thumbnail,
                    width: 600,
                    height: 600,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Failed to load image'); // Display error text for failed image
                    },
                  ),
                ),
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 2.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
