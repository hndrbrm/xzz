// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:xzz/xzz.dart';

void main() {
  final file = File('pcb/iPhone4S boardview.pcb');
  final content = file.readAsBytesSync();
  final xzz = Xzz.deserialize(content.iterator);
  final bytes = xzz.serialize();
  final output = File('output.pcb');
  output.writeAsBytesSync(bytes);
}
