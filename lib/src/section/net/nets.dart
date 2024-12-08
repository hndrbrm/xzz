// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../packet/serializable_packet.dart';
import 'net.dart';

final class Nets extends SerializablePacket<Net> {
  Nets.deserialize(Iterator<int> iterator)
  : super.deserialize(iterator, Net.deserialize);
}
