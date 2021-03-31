import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_gurus_challenger/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness_gurus_challenger/components/my_app.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import 'services/authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(
      child: StreamProvider<User>(
    create: (_) => AuthenticationService().user,
    child: MyApp(),
  )));
}
