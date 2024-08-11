import 'package:flutter/material.dart';
import 'package:s13a_more_riverpod/widgets/add_new_row.dart';
import 'package:s13a_more_riverpod/widgets/asyncvalue_data_list.dart';

class AsyncValueDemo extends StatelessWidget {
  const AsyncValueDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncNotifierProvider Demo'),
      ),
      body: const Column(
        children: [
          AddNewRow(),
          SizedBox(height: 10),
          Expanded(child: AsyncValueDataList()),
        ],
      ),
    );
  }
}
