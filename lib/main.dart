import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sonat_hrm_rewarded/src/packages/authentication_repository/lib/src/authentication_repository.dart';
import 'package:sonat_hrm_rewarded/src/service/firebase/firebase_options.dart';

import 'src/app/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    String environment = kDebugMode ? 'development' : 'production';
    await dotenv.load(fileName: '.env.$environment');
  } catch (e) {
    debugPrint('$e');
  }

  final authenticationRepository = AuthenticationRepository();

  runApp(MyApp(authenticationRepository: authenticationRepository));
}
