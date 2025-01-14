import 'dart:convert';
import 'dart:html' as html;

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_create_page/cubit/home_screen_state.dart';
import 'package:flutter_bloc_create_page/raw_code.dart';
import 'package:recase/recase.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final TextEditingController nameTextEditingController =
      TextEditingController();

  HomeScreenCubit() : super(const HomeScreenState()) {
    nameTextEditingController.addListener(() {
      final name = nameTextEditingController.text;
      emit(state.copyWith(name: name));
    });

    nameTextEditingController.text = 'HomeScreen';
  }

  @override
  Future<void> close() {
    nameTextEditingController.dispose();
    return super.close();
  }

  void setName(String name) {}

  void onTapDownload() {
    final nameTitleCase = state.name.titleCase;
    final namePascalCase = state.name.pascalCase;
    final nameSnakeCase = state.name.snakeCase;

    final pageStateFileBytes = utf8.encode(
      RawCode.pageState(
        nameSnakeCase: nameSnakeCase,
        namePascalCase: namePascalCase,
      ),
    );

    final pageCubitFileBytes = utf8.encode(
      RawCode.pageCubit(
        nameSnakeCase: nameSnakeCase,
        namePascalCase: namePascalCase,
      ),
    );

    final pageFileBytes = utf8.encode(
      RawCode.page(
        nameSnakeCase: nameSnakeCase,
        namePascalCase: namePascalCase,
        nameTitleCase: nameTitleCase,
      ),
    );

    final archive = Archive();

    archive.addFile(
      ArchiveFile(
        'cubit/${nameSnakeCase}_state.dart',
        pageStateFileBytes.length,
        pageStateFileBytes,
      ),
    );
    archive.addFile(
      ArchiveFile(
        'cubit/${nameSnakeCase}_cubit.dart',
        pageCubitFileBytes.length,
        pageCubitFileBytes,
      ),
    );

    archive.addFile(
      ArchiveFile(
        '${state.name.snakeCase}.dart',
        pageFileBytes.length,
        pageFileBytes,
      ),
    );

    final zippedData = ZipEncoder().encode(archive);
    final blob = html.Blob([Uint8List.fromList(zippedData)], 'application/zip');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', '$nameSnakeCase.zip')
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
