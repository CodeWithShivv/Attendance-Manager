// features/home/presentation/widgets/bottom_nav_bar.dart
import 'package:attendance_manager_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, int>(
      builder: (context, selectedIndex) {
        return BottomNavigationBar(
          currentIndex: selectedIndex, // Highlight the selected item
          onTap: (index) {
            context.read<HomeCubit>().changePage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Employees',
            ),
          ],
          selectedItemColor: Colors.blue, // Color for the selected item
          unselectedItemColor: Colors.grey, // Color for unselected items
        );
      },
    );
  }
}
