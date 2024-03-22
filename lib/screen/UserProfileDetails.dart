import 'package:flutter/material.dart';

class UserProfileDetails extends StatelessWidget {
  final String title;
  final String firstName;
  final String lastName;
  final String email;
  final String streetNumber;
  final String streetName;
  final String city;
  final String state;
  final String country;
  final int postcode;
  final String phone;
  final String cell;
  final String largePictureUrl;

  const UserProfileDetails({
    Key? key,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.streetNumber,
    required this.streetName,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.phone,
    required this.cell,
    required this.largePictureUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(largePictureUrl),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: $title $firstName $lastName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Address:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '$streetNumber $streetName, $city, $state, $country - $postcode',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: $phone',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Cell: $cell',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
