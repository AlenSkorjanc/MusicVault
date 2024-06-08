import 'package:flutter/material.dart';
import 'package:music_vault/pages/main/profile.dart';
import 'package:music_vault/pages/main/songs.dart';
import 'package:music_vault/pages/main/tuner.dart';
import 'package:music_vault/styles/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          // Tuner Page
          Tuner(),
          // Home Page
          Songs(),
          // Profile Page
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        backgroundColor: CustomColors.primaryColor,
        selectedItemColor: CustomColors.neutralColorLight,
        unselectedItemColor: CustomColors.neutralColorDark,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_rounded),
            label: 'Tuner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: 'Profile',
          )
        ],
      ),
    );
  }
}
