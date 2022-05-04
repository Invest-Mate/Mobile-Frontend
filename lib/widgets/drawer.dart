import 'package:crowd_application/screens/my_funds/myfunds_screen.dart';
import 'package:crowd_application/screens/my_transactions/all_transactions_screen.dart';
import 'package:crowd_application/services/5.auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/profile/profile_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Dash',
                style: TextStyle(
                  color: Color.fromRGBO(254, 161, 21, 1),
                ),
              ),
              Text(
                'Board',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DrawerListTile(
              icon: CupertinoIcons.person_alt_circle,
              title: 'My Profile',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            const Divider(height: 3, thickness: 2, endIndent: 15, indent: 15),
            DrawerListTile(
              title: 'My Fundraisers',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MyFundsScreen()),
                );
              },
              isImageIcon: true,
              imagePath: 'assets/images/strongbox.png',
            ),
            const Divider(height: 3, thickness: 2, endIndent: 15, indent: 15),
            DrawerListTile(
              icon: Icons.monetization_on_outlined,
              title: 'Transactions',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MyTransactionsScreen()),
                );
              },
            ),
            const Divider(height: 3, thickness: 2, endIndent: 15, indent: 15),
            if (FirebaseAuth.instance.currentUser != null)
              DrawerListTile(
                icon: Icons.logout,
                title: 'Log Out',
                onTap: () {
                  AuthService.firebase().logOut();
                  FirebaseAuth.instance.signOut();
                },
              ),
            Expanded(
                child: Center(
              child: Image.asset(
                'assets/images/img1.png',
                height: 250,
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    this.icon,
    this.isImageIcon = false,
    this.imagePath = '',
    required this.title,
    this.onTap,
  }) : super(key: key);
  final IconData? icon;
  final bool isImageIcon;
  final String title;
  final String imagePath;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: isImageIcon
          ? ImageIcon(
              AssetImage(imagePath),
              size: 35,
              color: const Color.fromRGBO(254, 161, 21, 1),
            )
          : Icon(
              icon,
              size: 35,
              color: const Color.fromRGBO(254, 161, 21, 1),
            ),
      title: Text(
        title,
        textScaleFactor: 1.5,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}
