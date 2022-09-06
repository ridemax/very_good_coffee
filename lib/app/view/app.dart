// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:very_good_coffee/favorite_images/cubit/favorite_images_cubit.dart';
import 'package:very_good_coffee/featured_image/cubit/featured_image_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';
import 'package:very_good_coffee/main_navigation/main_navigation.dart';
import 'package:very_good_coffee/photo_repository/photo_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final _photoRepository = PhotoRepository();
    return MaterialApp(
      // Theme code block below is courtesy of FlexColorScheme
      theme: FlexThemeData.light(
        scheme: FlexScheme.espresso,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.espresso,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.90,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 30,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      // If you do not have a themeMode switch, uncomment this line
      // to let the device system mode control the theme mode:
      // themeMode: ThemeMode.system,

      // Let's use dark mode always for the brew app
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteImagesCubit>(
            lazy: false,
            create: (BuildContext context) => FavoriteImagesCubit(_photoRepository),
          ),
          BlocProvider<FeaturedImageCubit>(
            create: (BuildContext context) => FeaturedImageCubit(
              _photoRepository,
              BlocProvider.of<FavoriteImagesCubit>(context),
            ),
          ),
        ],
        child: const MainNavigationPage(),
      ),
    );
  }
}
