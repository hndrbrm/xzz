// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../packet/serializable_packet.dart';
import 'image.dart';

final class Images extends SerializablePacket<Image> {
  Images.deserialize(Iterator<int> iterator)
  : super.deserialize(iterator, Image.deserialize);
}
