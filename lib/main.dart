import 'package:flutter/material.dart';
import 'package:flutter_cubit_create_page/home_page.dart';
import 'package:flutter_cubit_create_page/theme.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Highlighter.initialize(['dart']);
  final highlighterDarkTheme = await HighlighterTheme.loadDarkTheme();

  runApp(
    MaterialApp(
      title: 'Flutter Bloc Create Page',
      darkTheme: const MaterialTheme(TextTheme()).dark(),
      themeMode: ThemeMode.dark,
      home: HomePage(
        highlighter: Highlighter(
          language: 'dart',
          theme: highlighterDarkTheme,
        ),
      ),
    ),
  );
}
