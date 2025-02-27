// features/home/presentation/cubits/home_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

/// A Cubit to manage the navigation state for the bottom navigation bar,
/// tracking the selected tab index (e.g., 0 for Attendance, 1 for Employees).
class HomeCubit extends Cubit<int> {
  /// Creates a [HomeCubit] with an initial state of 0 (Attendance tab).
  HomeCubit() : super(0); // Start with Attendance (index 0)

  /// Changes the current page (tab) to the specified [index].
  /// Only accepts valid indices (0 or 1 for two tabs).
  void changePage(int index) {
    if (index >= 0 && index < 2) {
      // Assuming 2 tabs (Attendance and Employees)
      emit(index);
    }
  }
}
