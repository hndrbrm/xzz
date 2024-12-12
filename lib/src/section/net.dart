// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../bytes_helper/int_helper.dart';
import '../bytes_helper/iterator_helper.dart';
import '../bytes_helper/list_helper.dart';
import '../bytes_helper/string_helper.dart';
import '../serializable.dart';
import 'packet/byteable_packet.dart';

final class Net implements Serializable {
  const Net._({
    required this.index,
    required this.name,
  });

  final int index;
  final String name;

  @override
  List<int> toByte() => [
    ...(name.length + 8).toUint32List(),
    ...index.toUint32List(),
    ...name.toString8List(),
  ];

  @override
  Map<String, dynamic> toMap() => {
    'index': index,
    'name': name,
  };
}

extension NetIterator on Iterator<int> {
  Net toNet() {
    final length = read(4).toUint32();

    return Net._(
      index: read(4).toUint32(),
      name: read(length - 8).toString8(),
    );
  }
}

extension NetMap on Map<String, dynamic> {
  Net toNet() => Net._(
    index: this['index'],
    name: this['name'],
  );
}

extension NetsIterator on Iterator<int> {
  ByteablePacket<Net> toNets() => toByteablePacket((e) => e.toNet());
}

extension NetsMap on Map<String, dynamic> {
  ByteablePacket<Net> toNets() => toByteablePacket();
}
