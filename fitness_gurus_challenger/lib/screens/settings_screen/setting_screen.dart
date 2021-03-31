import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:fitness_gurus_challenger/components/settings/setting_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "settings";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot documentSnapshot = Provider.of<DocumentSnapshot>(context);

    if (documentSnapshot == null) {
      print('settings doc null');
      return Scaffold(
        appBar: AppBar(),
        body: SettingOptions(),
      );
    } else {
      return Scaffold(
        appBar: MainAppBar(),
        body: SettingOptions(),
      );
    }
  }
}
