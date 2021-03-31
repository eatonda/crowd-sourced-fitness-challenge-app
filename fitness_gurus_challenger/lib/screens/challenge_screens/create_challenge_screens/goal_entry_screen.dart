import 'package:fitness_gurus_challenger/components/create_challenge/goal_entry_form.dart';
import 'package:fitness_gurus_challenger/components/general/my_title.dart';
import 'package:flutter/material.dart';

class GoalEntryScreen extends StatelessWidget {
  static const routeName = 'goal_entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyTitle(title: 'Add a Goal to your Challenge'),
            GoalEntryForm(),
          ],
        ),
      ),
    );
  }
}
