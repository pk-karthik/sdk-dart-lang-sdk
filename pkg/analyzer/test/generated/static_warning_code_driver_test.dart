// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'static_warning_code_test.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(StaticWarningCodeTest_Driver);
  });
}

@reflectiveTest
class StaticWarningCodeTest_Driver extends StaticWarningCodeTest {
  @override
  bool get enableNewAnalysisDriver => true;

  @failingTest
  @override
  test_argumentTypeNotAssignable_ambiguousClassName() {
    return super.test_argumentTypeNotAssignable_ambiguousClassName();
  }
}
