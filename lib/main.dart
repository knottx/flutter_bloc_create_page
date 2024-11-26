import 'package:flutter/material.dart';
import 'package:flutter_bloc_create_page/home_screen.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Highlighter.initialize(['dart']);
  final highlighterDarkTheme = await HighlighterTheme.loadDarkTheme();

  runApp(
    MaterialApp(
      title: 'Flutter Bloc Cubit Create',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: HomeScreen(
        highlighter: Highlighter(
          language: 'dart',
          theme: highlighterDarkTheme,
        ),
      ),
    ),
  );
}
