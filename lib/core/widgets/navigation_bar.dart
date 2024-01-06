import 'package:flutter/material.dart';
import 'package:shelter_booking/core/core.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentPageIndex;
  final ValueChanged<int>? onDestinationSelected;
  final List<NavigationDestination> destinations;
  final List<Widget> destinationsBody;

  const AppNavigationBar({
    super.key,
    required this.currentPageIndex,
    this.onDestinationSelected,
    required this.destinations,
    required this.destinationsBody,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onDestinationSelected,
        indicatorColor: AppColors.blue,
        selectedIndex: currentPageIndex,
        destinations: destinations,
        animationDuration: const Duration(seconds: 1),
      ),
      body: destinationsBody[currentPageIndex],
    );
  }
}
