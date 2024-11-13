class RawCode {
  RawCode._();

  static String pageState({
    required String nameSnakeCase,
    required String namePascalCase,
  }) {
    return '''
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
''';
  }

  static String pageCubit({
    required String nameSnakeCase,
    required String namePascalCase,
  }) {
    return '''
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
''';
  }
}
