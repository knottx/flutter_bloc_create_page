import 'package:recase/recase.dart';

class RawCode {
  RawCode._();

  static String state(String name) {
    return '''
import 'package:equatable/equatable.dart';

enum ${name.pascalCase}Status {
  initial,
  loading,
  ready,
  failure,
  ;

  bool get isLoading => this == ${name.pascalCase}Status.loading;
}

class ${name.pascalCase}State extends Equatable {
  final ${name.pascalCase}Status status;
  final Object? error;

  const ${name.pascalCase}State({
    this.status = ${name.pascalCase}Status.initial,
    this.error,
  });

  @override
  List<Object?> get props => [
        status,
        error,
      ];

  ${name.pascalCase}State copyWith({
    ${name.pascalCase}Status? status,
    Object? error,
  }) {
    return ${name.pascalCase}State(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  ${name.pascalCase}State loading() {
    return copyWith(
      status: ${name.pascalCase}Status.loading,
    );
  }

  ${name.pascalCase}State ready() {
    return copyWith(
      status: ${name.pascalCase}Status.ready,
    );
  }

  ${name.pascalCase}State failure(
    Object error,
  ) {
    return copyWith(
      status: ${name.pascalCase}Status.failure,
      error: error,
    );
  }
}
''';
  }

  static String cubit(String name) {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';

import '${name.snakeCase}_state.dart';

class ${name.pascalCase}Cubit extends Cubit<${name.pascalCase}State> {
  ${name.pascalCase}Cubit() : super(const ${name.pascalCase}State());
}
''';
  }

  static String screen(String name) {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/${name.snakeCase}_cubit.dart';
import 'cubit/${name.snakeCase}_state.dart';

class ${name.pascalCase} extends StatelessWidget {
  const ${name.pascalCase}({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${name.pascalCase}Cubit(),
      child: const ${name.pascalCase}View(),
    );
  }
}

class ${name.pascalCase}View extends StatefulWidget {
  const ${name.pascalCase}View({super.key});

  @override
  State<${name.pascalCase}View> createState() => _${name.pascalCase}ViewState();
}

class _${name.pascalCase}ViewState extends State<${name.pascalCase}View> {
  late final ${name.pascalCase}Cubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<${name.pascalCase}Cubit>();
  }

  void _listener(BuildContext context, ${name.pascalCase}State state) {
    switch (state.status) {
      case ${name.pascalCase}Status.initial:
      case ${name.pascalCase}Status.loading:
      case ${name.pascalCase}Status.ready:
        break;

      case ${name.pascalCase}Status.failure:
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<${name.pascalCase}Cubit, ${name.pascalCase}State>(
      listener: _listener,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('${name.titleCase}'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('${name.titleCase}'),
        ),
      ),
    );
  }
}
''';
  }
}
