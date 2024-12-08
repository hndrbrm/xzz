// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

extension StringExtension on String {
  List<int> toString8List() => utf8.encode(this);
}
