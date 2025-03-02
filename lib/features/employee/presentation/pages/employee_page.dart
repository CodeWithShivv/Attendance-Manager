import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_bloc.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_event.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_state.dart';
import 'package:attendance_manager_app/features/employee/presentation/widgets/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addEmployee() {
    if (_controller.text.isNotEmpty) {
      context.read<EmployeeBloc>().add(AddEmployee(_controller.text));
      _focusNode.unfocus(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus(); 
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Input Section as a Sliver
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode, // Assign FocusNode
                        decoration: InputDecoration(
                          labelText: 'Employee Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          _focusNode.unfocus(); 
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _addEmployee,
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Employee List Section
            SliverFillRemaining(
              child: BlocListener<EmployeeBloc, EmployeeState>(
                listener: (context, state) {
                  if (state is EmployeeAdding) {
                    AlertDialogWidget.show(
                      context,
                      'Adding ${_controller.text}...',
                    );
                    _controller.clear();
                    _focusNode
                        .unfocus(); // Ensure keyboard is closed after clearing
                  } else if (state is EmployeeRemoving) {
                    AlertDialogWidget.show(context, 'Removing employee...');
                  } else if (state is EmployeeStateUpdated) {
                    AlertDialogWidget.hide(context);
                  }
                },
                child: BlocBuilder<EmployeeBloc, EmployeeState>(
                  builder: (context, state) {
                    if (state is EmployeeLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: const Text('Loading Employee Name'),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: null,
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is EmployeeLoaded) {
                      if (state.employees.isEmpty) {
                        return const Center(
                          child: Text(
                            'No employees found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) {
                          final employee = state.employees[index];
                          return Dismissible(
                            key: Key(employee.name), // Unique key for each item
                            direction:
                                DismissDirection
                                    .endToStart, // Swipe right to left
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              context.read<EmployeeBloc>().add(
                                RemoveEmployee(employee.name),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${employee.name} removed'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      context.read<EmployeeBloc>().add(
                                        AddEmployee(employee.name),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  employee.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    context.read<EmployeeBloc>().add(
                                      RemoveEmployee(employee.name),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is EmployeeError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(
                      child: Text(
                        'No employees found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
