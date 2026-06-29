import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:film_app/app.dart';
import 'package:film_app/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();
  runApp(const FilmApp());
}

