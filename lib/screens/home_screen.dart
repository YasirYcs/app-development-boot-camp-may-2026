import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'add_expense_screen.dart';
import 'dashboard_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current active tab index
  int _selectedIndex = 0;

  // List of main screens
  final List<Widget> _screens = const [
    DashboardScreen(),
    StatisticsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Index 2 is the 'Add' tab - open as a modal
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
      );
    } else {
      // Update selected index, adjusting for the 'Add' tab gap
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Map the bottom nav index to our _screens list index
    // Nav 0 -> Screen 0 (Dashboard)
    // Nav 1 -> Screen 1 (Stats)
    // Nav 3 -> Screen 2 (Profile)
    int screenIndex = _selectedIndex;
    if (_selectedIndex == 3) screenIndex = 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: screenIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 30),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
