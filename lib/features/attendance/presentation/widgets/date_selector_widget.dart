import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onSelectDate;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        OutlinedButton(
          onPressed: onSelectDate,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}