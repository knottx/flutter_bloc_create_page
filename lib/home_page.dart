import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_create_page/cubit/home_page_cubit.dart';
import 'package:flutter_cubit_create_page/cubit/home_page_state.dart';
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
  final ScrollController _scrollController = ScrollController();
  final ScrollController _stateScrollController = ScrollController();
  final ScrollController _cubitScrollController = ScrollController();
  final ScrollController _pageScrollController = ScrollController();

  final TextEditingController _nameTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTextEditingController.addListener(() {
      final name = _nameTextEditingController.text;
      context.read<HomePageCubit>().setName(name);
    });
    _nameTextEditingController.text = 'Home';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _stateScrollController.dispose();
    _cubitScrollController.dispose();
    _pageScrollController.dispose();
    _nameTextEditingController.dispose();
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
          code: '''
import 'package:equatable/equatable.dart';

enum ${namePascalCase}PageStatus {
  initial,
  loading,
  ready,
  failure,
  ;

  bool get isLoading => this == ${namePascalCase}PageStatus.loading;
}

class ${namePascalCase}PageState extends Equatable {
  final ${namePascalCase}PageStatus status;
  final Object? error;

  const ${namePascalCase}PageState({
    this.status = ${namePascalCase}PageStatus.initial,
    this.error,
  });

  @override
  List<Object?> get props => [
        status,
        error,
      ];

  ${namePascalCase}PageState copyWith({
    ${namePascalCase}PageStatus? status,
    Object? error,
  }) {
    return ${namePascalCase}PageState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  ${namePascalCase}PageState loading() {
    return copyWith(
      status: ${namePascalCase}PageStatus.loading,
    );
  }

  ${namePascalCase}PageState ready() {
    return copyWith(
      status: ${namePascalCase}PageStatus.ready,
    );
  }

  ${namePascalCase}PageState failure(
    Object error,
  ) {
    return copyWith(
      status: ${namePascalCase}PageStatus.failure,
      error: error,
    );
  }
}
''',
        ),
        const SizedBox(height: 16),
        _code(
          controller: _cubitScrollController,
          fileName: '${nameSnakeCase}_page_cubit.dart',
          code: '''
import 'package:flutter_bloc/flutter_bloc.dart';

import '${nameSnakeCase}_page_state.dart';

class ${namePascalCase}PageCubit extends Cubit<${namePascalCase}PageState> {
  bool _mounted = true;

  ${namePascalCase}PageCubit() : super(const ${namePascalCase}PageState());

  @override
  Future<void> close() {
    _mounted = false;
    return super.close();
  }

  void _emit(${namePascalCase}PageState newState) {
    if (_mounted) emit(newState);
  }
}
''',
        ),
        const SizedBox(height: 16),
        _code(
          controller: _pageScrollController,
          fileName: '${state.name.snakeCase}_page.dart',
          code: '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/${nameSnakeCase}_page_cubit.dart';
import 'cubit/${nameSnakeCase}_page_state.dart';

class ${namePascalCase}Page extends StatelessWidget {
  const ${namePascalCase}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${namePascalCase}PageCubit(),
      child: const ${namePascalCase}View(),
    );
  }
}

class ${namePascalCase}View extends StatefulWidget {
  const ${namePascalCase}View({super.key});

  @override
  State<${namePascalCase}View> createState() => _${namePascalCase}ViewState();
}

class _${namePascalCase}ViewState extends State<${namePascalCase}View> {
  ${namePascalCase}PageCubit get _cubit {
    return context.read<${namePascalCase}PageCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<${namePascalCase}PageCubit, ${namePascalCase}PageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('$nameTitleCase'),
            centerTitle: true,
          ),
          body: const Center(
            child: Text('$nameTitleCase'),
          ),
        );
      },
      listener: _listener,
    );
  }

  void _listener(BuildContext context, ${namePascalCase}PageState state) {
    switch (state.status) {
      case ${namePascalCase}PageStatus.initial:
      case ${namePascalCase}PageStatus.loading:
      case ${namePascalCase}PageStatus.ready:
        break;

      case ${namePascalCase}PageStatus.failure:
        break;
    }
  }
}
''',
        ),
      ],
    );
  }

  Widget _nameField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _nameTextEditingController,
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
