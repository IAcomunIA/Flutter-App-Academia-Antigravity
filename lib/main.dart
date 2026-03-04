import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar sqflite_ffi para desktop/web
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  runApp(
    const ProviderScope(
      child: AntigravityApp(),
    ),
  );
}
