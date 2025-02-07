import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qourz/pages/activity_page.dart';
import 'package:qourz/pages/explore_page.dart';
import 'package:qourz/pages/marketPlace/listing_page.dart';
import 'package:qourz/pages/profile_page.dart';
import 'package:qourz/pages/search_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1; // Marketplace is selected initially

  final  List<Widget> _pages = [
     const ExplorePage(),
    const ListingPage(),
    const SearchPage(),
    const ActivityPage(),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Marketplace'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: 'Profile'),
        ],

        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

