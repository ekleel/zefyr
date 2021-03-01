// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/home.dart';

/// Sets delegates
const kLocalizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  DefaultCupertinoLocalizations.delegate,
];

/// Sets local
const kLocale = Locale('ar', 'SA');

/// Sets supported local
const kSupportedLocales = [
  Locale('ar', 'SA'),
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RendererBinding.instance.initPersistentFrameCallback();
  runApp(ZefyrApp());
}

class ZefyrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: kLocale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: kLocalizationsDelegates,
      debugShowCheckedModeBanner: false,
      title: 'Zefyr - rich-text editor for Flutter',
      home: HomePage(),
    );
  }
}
