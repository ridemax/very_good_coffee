// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/main_navigation/main_navigation.dart';

void main() {
  group('App', () {
    testWidgets('renders MainNavigation page', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(MainNavigationPage), findsOneWidget);
    });
  });
}
