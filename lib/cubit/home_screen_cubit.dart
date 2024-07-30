import 'dart:convert';
import 'dart:js_interop';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_create_page/cubit/home_screen_state.dart';
import 'package:flutter_bloc_create_page/raw_code.dart';
import 'package:recase/recase.dart';
import 'package:web/web.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final TextEditingController nameTextEditingController =
      TextEditingController();

  HomeScreenCubit() : super(const HomeScreenState()) {
    nameTextEditingController.addListener(() {
      final name = nameTextEditingController.text;
      emit(
        state.copyWith(
          name: name,
          stateCode: RawCode.state(name),
          cubitCode: RawCode.cubit(name),
          screenCode: RawCode.screen(name),
        ),
      );
    });

    nameTextEditingController.text = 'HomeScreen';
  }

  @override
  Future<void> close() {
    nameTextEditingController.dispose();
    return super.close();
  }

  void onTapDownload() {
    final archive = Archive();

    final nameSnakeCase = state.name.snakeCase;

    final stateCodeFileBytes = utf8.encode(state.stateCode);
    archive.addFile(
      ArchiveFile(
        'cubit/${nameSnakeCase}_state.dart',
        stateCodeFileBytes.length,
        stateCodeFileBytes,
      ),
    );

    final cubitCodeFileBytes = utf8.encode(state.cubitCode);
    archive.addFile(
      ArchiveFile(
        'cubit/${nameSnakeCase}_cubit.dart',
        cubitCodeFileBytes.length,
        cubitCodeFileBytes,
      ),
    );

    final screenCodeFileBytes = utf8.encode(state.screenCode);
    archive.addFile(
      ArchiveFile(
        '$nameSnakeCase.dart',
        screenCodeFileBytes.length,
        screenCodeFileBytes,
      ),
    );

    final zippedData = Uint8List.fromList(ZipEncoder().encode(archive));

    String url = URL.createObjectURL(
      Blob([zippedData.toJS].toJS, BlobPropertyBag(type: 'application/zip')),
    );

    Document htmlDocument = document;
    HTMLAnchorElement anchor =
        htmlDocument.createElement('a') as HTMLAnchorElement;
    anchor.href = url;
    anchor.style.display = '$nameSnakeCase.zip';
    anchor.download = '$nameSnakeCase.zip';
    document.body!.add(anchor);
    anchor.click();
    anchor.remove();
  }
}
