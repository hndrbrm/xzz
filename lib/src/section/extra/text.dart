// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'resistance_type.dart';
import 'text_type.dart';

typedef Text = String;

extension TextOnTextType on TextType {
  Text toText() => content;
}

extension TextOnResistanceType on ResistanceType {
  Text toText() => content;
}
