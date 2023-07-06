import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intagram/providers/user_provider.dart';
import 'package:intagram/screens/add_screen.dart';
import 'package:intagram/screens/favorite_screen.dart';
import 'package:intagram/screens/home_screen.dart';
import 'package:intagram/screens/profile_screen.dart';
import 'package:intagram/screens/search_screen.dart';
import 'package:intagram/ultils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _currenIndex = 0;
  static final List<Widget> _page = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    const AddScreen(),
    const FavoriteScreen(),
    ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    )
  ];
  void _ontapPage(int index) {
    setState(() {
      _currenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getuser;
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: user == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _page[_currenIndex],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          iconSize: 34,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          currentIndex: _currenIndex,
          onTap: _ontapPage,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
                backgroundColor: mobileBackgroundColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
                backgroundColor: mobileBackgroundColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                label: '',
                backgroundColor: mobileBackgroundColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: '',
                backgroundColor: mobileBackgroundColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
                backgroundColor: mobileBackgroundColor),
          ],
        ));
  }
}
