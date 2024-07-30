import 'package:flutter/material.dart';
import 'package:flutter_bloc_create_page/home_screen.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Highlighter? _highlighter;
  bool _isHighlighterLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeHighlighter();
  }

  Future<void> _initializeHighlighter() async {
    await Highlighter.initialize(['dart']);
    final highlighterDarkTheme = await HighlighterTheme.loadDarkTheme();

    setState(() {
      _highlighter = Highlighter(language: 'dart', theme: highlighterDarkTheme);
      _isHighlighterLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc Cubit Create',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home:
          _isHighlighterLoaded
              ? HomeScreen(highlighter: _highlighter!)
              : const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
    );
  }
}
