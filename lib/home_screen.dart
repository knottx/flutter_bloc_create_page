import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_create_page/cubit/home_screen_cubit.dart';
import 'package:flutter_bloc_create_page/cubit/home_screen_state.dart';
import 'package:recase/recase.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class HomeScreen extends StatelessWidget {
  final Highlighter highlighter;

  const HomeScreen({super.key, required this.highlighter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => HomeScreenCubit(), child: HomeView(highlighter: highlighter));
  }
}

class HomeView extends StatefulWidget {
  final Highlighter highlighter;

  const HomeView({super.key, required this.highlighter});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeScreenCubit get _cubit {
    return context.read<HomeScreenCubit>();
  }

  final ScrollController _scrollController = ScrollController();
  final ScrollController _stateCodeScrollController = ScrollController();
  final ScrollController _cubitCodeScrollController = ScrollController();
  final ScrollController _screenCodeScrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _stateCodeScrollController.dispose();
    _cubitCodeScrollController.dispose();
    _screenCodeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: SafeArea(child: Center(child: Container(constraints: const BoxConstraints(maxWidth: 600), child: _body()))),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        final name = state.name;
        return Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _nameField(),
            _code(controller: _stateCodeScrollController, fileName: '${name.snakeCase}_state.dart', code: state.stateCode),
            _code(controller: _cubitCodeScrollController, fileName: '${name.snakeCase}_cubit.dart', code: state.cubitCode),
            _code(controller: _screenCodeScrollController, fileName: '${name.snakeCase}.dart', code: state.screenCode),
          ],
        );
      },
    );
  }

  Widget _nameField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cubit.nameTextEditingController,
                style: const TextStyle(fontFamily: 'Consolas'),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 1)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              spacing: 4,
              children: [
                IconButton.filledTonal(onPressed: _cubit.onTapDownload, icon: const Icon(Icons.download)),
                Text('Download', style: TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _code({required ScrollController controller, required String fileName, required String code}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(fileName, style: const TextStyle(fontFamily: 'Consolas'), textAlign: TextAlign.left),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.black),
                child: IntrinsicHeight(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: Scrollbar(
                          controller: controller,
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Text.rich(widget.highlighter.highlight(code), style: const TextStyle(fontFamily: 'Consolas')),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton.filledTonal(
                          onPressed: () {
                            _onTapCopy(code);
                          },
                          icon: const Icon(Icons.copy, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapCopy(String data) {
    Clipboard.setData(ClipboardData(text: data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 8), Text('Copied!')],
        ),
      ),
    );
  }
}
