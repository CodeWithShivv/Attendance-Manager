import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AttendanceSkeletonWidget extends StatelessWidget {
  const AttendanceSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Date: Loading...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(onPressed: null, child: const Text('Select Date')),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (_, __) => Card(
                child: ListTile(
                  title: const Text('Loading Employee'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: null,
                        child: const Text('In: --:-- --'),
                      ),
                      TextButton(
                        onPressed: null,
                        child: const Text('Out: --:-- --'),
                      ),
                      const Text('OT: 0.0h'),
                    ],
                  ),
                  trailing: const Text('Present'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Update Attendance'),
          ),
        ],
      ),
    );
  }
}