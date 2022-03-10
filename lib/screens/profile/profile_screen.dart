import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  final String profileImgUrl =
      'https://img.etimg.com/thumb/msid-50318894,width-650,imgsize-337990,,resizemode-4,quality-100/.jpg';
  final String userName = 'Sundar Pichai';
  final String email = 'therealsundarpichai@gmail.com';
  final String dob = '20 April 2001';
  final String aadhar = '4815 2659 1584';
  final String aadress = 'Bramhapuri, India';
  final String contact = '+91 48156 98452';

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      radius: deviceWidth * 0.2,
                      backgroundImage: NetworkImage(profileImgUrl),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: deviceWidth * 0.4),
                    child: FittedBox(
                      child: Text(
                        userName.toUpperCase(),
                        textScaleFactor: 1.3,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: deviceWidth * 0.8),
                    child: FittedBox(
                      child: Text(
                        email,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Heading(text: 'Details'),

                  // const Heading(text: 'Contact'),
                  CustomListTile(
                    title: contact,
                    substring: '',
                    leading: const Icon(
                      Icons.phone,
                    ),
                    function: () {},
                  ),
                  // const Heading(text: 'D.O.B'),
                  CustomListTile(
                    title: dob,
                    substring: '',
                    leading: const Icon(
                      Icons.calendar_month,
                    ),
                    function: () {},
                  ),
                  // const Heading(text: 'Aadhar Number'),
                  CustomListTile(
                    title: aadhar,
                    substring: '',
                    leading:
                        const ImageIcon(AssetImage('assets/images/aadhar.png')),
                    function: () {},
                  ),
                  // const Heading(text: 'Address'),
                  CustomListTile(
                    title: aadress,
                    substring: '',
                    leading: const Icon(
                      Icons.pin_drop_rounded,
                    ),
                    function: () {},
                  ),
                  const Heading(text: 'Your Cards'),
                  CustomListTile(
                    title: '**** **** **45',
                    substring: '',
                    leading: const Icon(Icons.credit_card),
                    function: () {},
                  ),
                  CustomListTile(
                    title: '**** **** **58',
                    substring: '',
                    leading: const Icon(Icons.credit_card),
                    function: () {},
                  ),
                  CustomListTile(
                    title: '**** **** **26',
                    substring: '',
                    leading: const Icon(Icons.credit_card),
                    function: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.title = '',
    this.substring = '',
    required this.leading,
    required this.function,
  }) : super(key: key);
  final String title;
  final String substring;
  final Widget leading;
  final Function() function;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        onTap: function,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        minLeadingWidth: 20,
        title: Text(
          title,
          textScaleFactor: 1,
          style: const TextStyle(
            // fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: leading,
        ),
        trailing: IconButton(
          onPressed: function,
          icon: const Icon(
            CupertinoIcons.right_chevron,
          ),
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  const Heading({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.blueGrey,
      ),
    );
  }
}
