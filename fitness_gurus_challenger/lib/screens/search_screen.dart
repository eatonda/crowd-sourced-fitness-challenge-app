import 'package:fitness_gurus_challenger/components/general/main_app_bar_.dart';
import 'package:fitness_gurus_challenger/components/search_form.dart';
import 'package:fitness_gurus_challenger/models/search_parameters.dart';
import 'package:fitness_gurus_challenger/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../components/general/my_title.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search_screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthenticationService authenticationService = AuthenticationService();
  SearchParameters searchParameters = SearchParameters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyTitle(title: 'Search for a Challenge'),
            SearchForm(),
          ],
        ),
      ),
    );
  }
}
