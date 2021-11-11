import 'dart:async';

import 'package:bytebank_contato_2/components/container.dart';
import 'package:bytebank_contato_2/screens/counter.dart';
import 'package:bytebank_contato_2/screens/darshboard.dart';
import 'package:bytebank_contato_2/screens/name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/localization.dart';
import 'models/name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FirebaseCrashlytics.instance.setUserIdentifier('alura123');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runZonedGuarded<Future<void>>(() async {
    runApp(const BytebankApp());
  }, FirebaseCrashlytics.instance.recordError);


} // usando o firebase

class LogObserver extends BlocObserver{
  @override
  void onChange(BlocBase bloc, Change change) {
   print('${bloc.runtimeType} > $change');
    super.onChange(bloc, change);
  }
}// na pratica evitar o log, pois ele pode vazar informações sensiveis para o log como email...

class BytebankApp extends StatelessWidget {
  const BytebankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bloc.observer = LogObserver();

    return BlocProvider(
      create: (context) => NameCubit('User'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LocalizationContainer(
          child: const DashboardContainer(),
        ),
      ),
    );
  }
}

