import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_create_page/cubit/home_page_cubit.dart';
import 'package:flutter_cubit_create_page/cubit/home_page_state.dart';
import 'package:flutter_cubit_create_page/raw_code.dart';
import 'package:recase/recase.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class HomePage extends StatelessWidget {
  final Highlighter highlighter;

  const HomePage({
    super.key,
    required this.highlighter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit(),
      child: HomeView(
        highlighter: highlighter,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  final Highlighter highlighter;

  const HomeView({
    super.key,
    required this.highlighter,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomePageCubit get _cubit {
    return context.read<HomePageCubit>();
  }

  final ScrollController _scrollController = ScrollController();
  final ScrollController _stateScrollController = ScrollController();
  final ScrollController _cubitScrollController = ScrollController();
  final ScrollController _pageScrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _stateScrollController.dispose();
    _cubitScrollController.dispose();
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
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
                child: SafeArea(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: _body(state),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _body(
    HomePageState state,
  ) {
    final nameTitleCase = state.name.titleCase;
    final namePascalCase = state.name.pascalCase;
    final nameSnakeCase = state.name.snakeCase;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _nameField(),
        const SizedBox(height: 16),
        _code(
          controller: _stateScrollController,
          fileName: '${nameSnakeCase}_page_state.dart',
          code: RawCode.pageState(
            nameSnakeCase: nameSnakeCase,
            namePascalCase: namePascalCase,
          ),
        ),
        const SizedBox(height: 16),
        _code(
          controller: _cubitScrollController,
          fileName: '${nameSnakeCase}_page_cubit.dart',
          code: RawCode.pageCubit(
            nameSnakeCase: nameSnakeCase,
            namePascalCase: namePascalCase,
          ),
        ),
        const SizedBox(height: 16),
        _code(
          controller: _pageScrollController,
          fileName: '${state.name.snakeCase}_page.dart',
          code: RawCode.page(
            nameSnakeCase: nameSnakeCase,
            namePascalCase: namePascalCase,
            nameTitleCase: nameTitleCase,
          ),
        ),
      ],
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
                style: const TextStyle(
                  fontFamily: 'Consolas',
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton.filledTonal(
              onPressed: _cubit.onTapDownload,
              icon: const Icon(
                Icons.download,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _code({
    required ScrollController controller,
    required String fileName,
    required String code,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                fileName,
                style: const TextStyle(
                  fontFamily: 'Consolas',
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black,
                ),
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
                            child: Text.rich(
                              widget.highlighter.highlight(code),
                              style: const TextStyle(
                                fontFamily: 'Consolas',
                              ),
                            ),
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
                          icon: const Icon(
                            Icons.copy,
                            size: 16,
                          ),
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

  void _onTapCopy(
    String data,
  ) {
    Clipboard.setData(
      ClipboardData(text: data),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text('Copied!'),
          ],
        ),
      ),
    );
  }
}
