// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'package:fast_gbk/fast_gbk.dart';

import '../section/extra/resistance_type.dart';
import '../section/extra/text_type.dart';
import 'bytes.dart';

typedef Text = String;

extension TextOnList on Bytes {
  Text toText() => gbk.decode(this);
}

extension TextOnResistanceType on ResistanceType {
  Text toText() => content;
}

extension TextOnTextType on TextType {
  Text toText() => content;
}
