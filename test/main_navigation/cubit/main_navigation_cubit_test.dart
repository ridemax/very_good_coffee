// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:very_good_coffee/main_navigation/main_navigation.dart';

void main() {
  group('MainNavigationCubit', () {
    test('initial state is 0', () {
      expect(MainNavigationCubit().state, equals(0));
    });

    blocTest<MainNavigationCubit, int>(
      'emits [1] when current tab is set to 1',
      build: MainNavigationCubit.new,
      act: (cubit) => cubit.setCurrentTabIndex(1),
      expect: () => [equals(1)],
    );

    blocTest<MainNavigationCubit, int>(
      'emits [0] when current tab is set to 0',
      build: MainNavigationCubit.new,
      act: (cubit) => cubit.setCurrentTabIndex(0),
      expect: () => [equals(0)],
    );
  });
}
