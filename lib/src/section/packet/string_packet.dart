// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../bytes_helper/string_helper.dart';
import 'length_packet.dart';

class StringPacket extends LengthPacket {
  StringPacket._(String string)
  : super(string.toString8List());

  StringPacket.deserialize(super.iterator)
  : super.deserialize();

  String get string => content.toString8();
}

extension StringPacketExtension on String {
  StringPacket toPacket() => StringPacket._(this);
}
