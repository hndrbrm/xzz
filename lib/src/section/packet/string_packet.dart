// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import 'length_packet.dart';

class StringPacket extends LengthPacket implements Jsonable {
  const StringPacket(super.content);

  String get string => content.toBytes().toString8();

  @override
  JsonMap toJson() => { 'string': string }.toJsonMap();
}

extension StringPacketOnIterator on Iterator<int> {
  StringPacket? toStringPacket() {
    final content = toLengthPacket()?.content;
    return content == null ? null : StringPacket(content);
  }
}

extension StringPacketOnMap on Map<String, dynamic> {
  StringPacket toStringPacket() {
    final string = this['string'] as String;
    return string.toStringPacket();
  }
}

extension StringPacketOnString on String {
  StringPacket toStringPacket() {
    final content = toBytes().toBytesable();
    return StringPacket(content);
  }
}
