import 'package:attendance_manager_app/core/navigation/app_router.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_bloc.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_event.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_state.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  EmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Employee Name'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<EmployeeBloc>().add(
                        AddEmployee(_controller.text),
                      );
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is EmployeeLoaded) {
                  return ListView.builder(
                    itemCount: state.employees.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.employees[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<EmployeeBloc>().add(
                              RemoveEmployee(state.employees[index].name),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is EmployeeError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('No employees found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
