import 'package:crowd_application/screens/auth/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  final bool isLoggedIn = false;
  final String defaultImg =
      'https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=';
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
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      radius: deviceWidth * 0.2,
                      backgroundImage: NetworkImage(
                        isLoggedIn ? profileImgUrl : defaultImg,
                      ),
                    ),
                  ),
                  if (!isLoggedIn)
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text('Sign Up')),
                  if (isLoggedIn)
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
                  if (isLoggedIn)
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
                    leading: const Icon(
                      Icons.phone,
                    ),
                  ),
                  // const Heading(text: 'D.O.B'),
                  CustomListTile(
                    title: dob,
                    leading: const Icon(
                      Icons.calendar_month,
                    ),
                  ),
                  // const Heading(text: 'Aadhar Number'),
                  CustomListTile(
                    title: aadhar,
                    leading:
                        const ImageIcon(AssetImage('assets/images/aadhar.png')),
                  ),
                  // const Heading(text: 'Address'),
                  CustomListTile(
                    title: aadress,
                    leading: const Icon(
                      Icons.pin_drop_rounded,
                    ),
                  ),
                  const Heading(text: 'Your Cards'),
                  const CustomListTile(
                    title: '**** **** **45',
                    leading: Icon(Icons.credit_card),
                  ),
                  const CustomListTile(
                    title: '**** **** **58',
                    leading: Icon(Icons.credit_card),
                  ),
                  const CustomListTile(
                    title: '**** **** **26',
                    leading: Icon(Icons.credit_card),
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
    required this.leading,
    // ignore: avoid_init_to_null
    this.onTap = null,
  }) : super(key: key);
  final String title;

  final Widget leading;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        onTap: onTap,
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
          onPressed: onTap,
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
