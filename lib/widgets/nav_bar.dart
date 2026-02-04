import 'package:expense_tracker/style/app_styles.dart';

import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    // Returnează DOAR BottomAppBar, nu Scaffold!
    return BottomAppBar(
      height: 70,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.0,
      color: const Color.from(
        alpha: 0.8,
        red: 0.118,
        green: 0.133,
        blue: 0.157,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Partea stângă (Home, Stats)
          Row(
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              const SizedBox(width: 20),
              _buildNavItem(
                1,
                Icons.pie_chart_outline,
                Icons.pie_chart,
                'Stats',
              ),
            ],
          ),
          // Partea dreaptă (Wallet, Profile)
          Row(
            children: [
              _buildNavItem(
                2,
                Icons.account_balance_wallet_outlined,
                Icons.account_balance_wallet,
                'Wallet',
              ),
              const SizedBox(width: 20),
              _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () => widget.onDestinationSelected(index),
      child: Container(
        width: 60, // Fixed width for touch target
        color: Colors.transparent, // Hit test
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppColors.globalAccentColor
                  : Colors.grey, // Active green, inactive grey
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.globalAccentColor : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
