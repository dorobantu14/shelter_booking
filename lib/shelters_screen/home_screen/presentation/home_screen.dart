import 'package:flutter/material.dart';
import 'package:shelter_booking/core/colors/colors.dart';
import 'package:shelter_booking/shelters_screen/presentation/shelters_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: AppColors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.night_shelter_outlined),
            label: 'Shelters',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const SheltersScreen(),
        /// Profile page
        const Placeholder(),
      ][currentPageIndex],
    );
  }
}
