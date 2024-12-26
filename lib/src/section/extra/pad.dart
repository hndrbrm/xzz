// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import 'diode.dart';

final class Pad implements Bytesable, Jsonable {
  const Pad._(this._diodes);

  final List<Diode> _diodes;

  @override
  Bytes toBytes() => toJson().toBytes();

  @override
  JsonList toJson() => _diodes
    .map((e) => e.toJson())
    .toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Pad &&
    listEqual(other._diodes, _diodes);

  @override
  int get hashCode => Object.hashAll(_diodes);
}

extension PadOnList on List<Object?> {
  Pad toPad() => Pad._(
    map((e) => e! as Map<String, Object?>)
      .map((e) => e.toDiode())
      .toList()
  );
}
