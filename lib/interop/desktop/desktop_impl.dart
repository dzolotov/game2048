import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:ui';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:game2048/constants.dart';
import 'package:game2048/interop/desktop/generated_bindings.dart';
import 'package:game2048/methodchannel/notifications_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:universal_platform/universal_platform.dart';

late SharedPreferences prefs;

late Pointer<NativePerson> personPtr;
late Pointer<NativeFameEntry> emptyEntry;

late NotificationsPlugin notificationsPlugin;

Future<void> initEnvironment() async {
  notificationsPlugin = NotificationsPlugin();
  prefs = await SharedPreferences.getInstance();
  personPtr = calloc<NativePerson>();
  final initialName = 'Shmr 2024'.toNativeUtf8(allocator: calloc);
  personPtr.ref.name = initialName.cast();
  const initialSalutation = '';
  personPtr.ref.salutation =
      initialSalutation.toNativeUtf8(allocator: calloc).cast();
  emptyEntry = calloc<NativeFameEntry>();
  emptyEntry.ref.score = 0;
  emptyEntry.ref.name = ''.toNativeUtf8(allocator: calloc).cast();
  if (runWebViewTitleBarWidget([])) {
    return;
  }
  await notificationsPlugin.requestPermission();
}

class Player {
  String get nickname => personPtr.ref.name.cast<Utf8>().toDartString();

  set salutation(String value) {
    //avoid memory leak
    calloc.free(personPtr.ref.salutation);
    personPtr.ref.salutation = value.toNativeUtf8(allocator: calloc).cast();
  }

  void setName(String name) {
    //avoid memory leak
    calloc.free(personPtr.ref.name);
    personPtr.ref.name = name.toNativeUtf8(allocator: calloc).cast();
  }

  String greeting() {
    Pointer<Char>? result;
    using((arena) {
      //используем аллокатор arena для автоматического управления памятью
      final space = arena.using(' ', (p) {
        debugPrint('Memory automatically released');
      }).toNativeUtf8(allocator: arena);

      Pointer<Char> playerName;
      //если не пустое приветствие - соединяем его с пробелом и именем игрока
      if (personPtr.ref.salutation.value != 0) {
        //в пустой строке первый байт будет =0
        playerName = lib.mergeStrings(personPtr.ref.salutation, space.cast());
        playerName = lib.mergeStrings(playerName, personPtr.ref.name);
      } else {
        //если нет приветствия - просто используем имя игрока
        playerName = personPtr.ref.name;
      }
      //соединяем префикс Hi.
      final hi = arena.using('Hi (from desktop), ', (_) {
        debugPrint('Hi from desktop string deallocated');
      }).toNativeUtf8(allocator: arena);
      result = lib.mergeStrings(hi.cast(), playerName);
    });
    if (result != null) {
      final r = result!.cast<Utf8>().toDartString();
      lib.memory_free(result!);
      return r;
    } else {
      return '?';
    }
  }
}

class FameEntry {
  String player = '';
  int score = 0;
}

extension on NativeFameEntry {
  FameEntry toFameEntry() => FameEntry()
    ..player = name.cast<Utf8>().toDartString()
    ..score = score;
}

List<FameEntry> get fameRecords {
  Pointer<NativeFameEntry> current = lib.getFirst();
  List<FameEntry> result = [];
  //связанный список -> Dart List
  while (current.address != 0) {
    result.add(current.ref.toFameEntry());
    current = current.ref.next.cast();
  }
  return result;
}

class Fame {
  void add(String player, int score) {
    final nativeEntry = calloc<NativeFameEntry>();
    nativeEntry.ref.name = player.toNativeUtf8(allocator: calloc).cast();
    nativeEntry.ref.score = score;
    lib.addFameEntry(nativeEntry);
  }

  void clear() => lib.clearFameEntries();
}

FameEntry createEmpty() => emptyEntry.ref.toFameEntry();

// class Fame {
//   List<FameEntry> records = [];
//
//   void add(String player, int score) {
//     records.add(FameEntry()
//       ..player = player
//       ..score = score);
//   }
// }

final _fame = Fame();

Fame get fame => _fame;

// List<FameEntry> get fameRecords => fame.records;

// FameEntry createEmpty() {
//   final empty = FameEntry()
//     ..player = ''
//     ..score = -1;
//   return empty;
// }

// class Player {
//   String nickname = '';
//
//   String salutation = '';
//
//   void setName(String name) => nickname = name;
//
//   String greeting() => '${'Hi, $salutation'.trim()} $nickname';
// }
//
final _player = Player();

Player get currentPlayer => _player;

bool get confirmForceQuit => true;

//ignore for desktop
void setPathStrategy() {}

//also ignore for desktop
void registerIFrame(BuildContext context) {
  Future(
    () async {
      final webview = await WebviewWindow.create();
      webview.launch(manualUrl);
      notificationsPlugin.showNotification(
        title: 'Manual is shown',
        subtitle: 'User manual is ready',
        body: 'You can read the manual in the separate window',
      );
      context.go('/');
    },
  );
}

final nativeLibrary = ffi.DynamicLibrary.process();
final lib = NativeLibrary(nativeLibrary);

Future<int> power11() async {
  return 2048;
  return lib.power(11);
}

Future<String> getTitle() async {
  // return "Ya.Game.Desktop/Mobile 2048";
  final power = await power11();
  const prefix = 'Ya.Game.Desktop/Mobile ';
  final content = power.toString();
  final p = lib.mergeStrings(
    prefix.toNativeUtf8().cast(),
    content.toNativeUtf8().cast(),
  );
  final s = p.cast<Utf8>().toDartString();
  lib.memory_free(p);
  return s;
}

void makeScreenshot(BuildContext context, GlobalKey screenshotKey) {
  const savedMessage = 'Screenshot has been saved into the clipboard';
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    final scr = screenshotKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary;
    final image = await scr.toImage();
    final bytes = (await image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
    final sc = SystemClipboard.instance;
    sc?.write([
      DataWriterItem(suggestedName: 'clipboard.png')..add(Formats.png(bytes))
    ]);
    if (UniversalPlatform.isMacOS) {
      showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => const CupertinoAlertDialog(
          content: Text(savedMessage),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(savedMessage),
        ),
      );
    }
  });
}

class GLWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

String? getSetting(String key) => prefs.getBool(key)?.toString();

void setSetting(String key, String value) =>
    prefs.setBool(key, bool.tryParse(value) ?? false);

Future<bool?> showNotification(
        {required String title,
        required String subtitle,
        required String body}) =>
    notificationsPlugin.showNotification(
      title: title,
      subtitle: subtitle,
      body: body,
    );
