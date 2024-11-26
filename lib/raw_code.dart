class RawCode {
  RawCode._();

  static String pageState({
    required String nameSnakeCase,
    required String namePascalCase,
  }) {
    return '''
import 'package:equatable/equatable.dart';

enum ${namePascalCase}Status {
  initial,
  loading,
  ready,
  failure,
  ;

  bool get isLoading => this == ${namePascalCase}Status.loading;
}

class ${namePascalCase}State extends Equatable {
  final ${namePascalCase}Status status;
  final Object? error;

  const ${namePascalCase}State({
    this.status = ${namePascalCase}Status.initial,
    this.error,
  });

  @override
  List<Object?> get props => [
        status,
        error,
      ];

  ${namePascalCase}State copyWith({
    ${namePascalCase}Status? status,
    Object? error,
  }) {
    return ${namePascalCase}State(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  ${namePascalCase}State loading() {
    return copyWith(
      status: ${namePascalCase}Status.loading,
    );
  }

  ${namePascalCase}State ready() {
    return copyWith(
      status: ${namePascalCase}Status.ready,
    );
  }

  ${namePascalCase}State failure(
    Object error,
  ) {
    return copyWith(
      status: ${namePascalCase}Status.failure,
      error: error,
    );
  }
}
''';
  }

  static String pageCubit({
    required String nameSnakeCase,
    required String namePascalCase,
  }) {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';

import '${nameSnakeCase}_page_state.dart';

class ${namePascalCase}Cubit extends Cubit<${namePascalCase}State> {
  bool _mounted = true;

  ${namePascalCase}Cubit() : super(const ${namePascalCase}State());

  @override
  Future<void> close() {
    _mounted = false;
    return super.close();
  }

  void _emit(${namePascalCase}State newState) {
    if (_mounted) emit(newState);
  }
}
''';
  }

  static String page({
    required String nameSnakeCase,
    required String namePascalCase,
    required String nameTitleCase,
  }) {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/${nameSnakeCase}_page_cubit.dart';
import 'cubit/${nameSnakeCase}_page_state.dart';

class ${namePascalCase} extends StatelessWidget {
  const ${namePascalCase}({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${namePascalCase}Cubit(),
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
  ${namePascalCase}Cubit get _cubit {
    return context.read<${namePascalCase}Cubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<${namePascalCase}Cubit, ${namePascalCase}State>(
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

  void _listener(BuildContext context, ${namePascalCase}State state) {
    switch (state.status) {
      case ${namePascalCase}Status.initial:
      case ${namePascalCase}Status.loading:
      case ${namePascalCase}Status.ready:
        break;

      case ${namePascalCase}Status.failure:
        break;
    }
  }
}
''';
  }
}
