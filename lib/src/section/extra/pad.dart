// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import 'diode.dart';

final class Pad implements Serializable {
  const Pad._(this.diodes);

  final List<Diode> diodes;

  @override
  List<int> toBytes() => toJson().toBytes();

  @override
  JsonList toJson() => diodes
    .map((e) => e.toJson())
    .toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Pad &&
    listEqual(other.diodes, diodes);

  @override
  int get hashCode => Object.hashAll(diodes);
}

extension PadMap on List<Object?> {
  Pad toPad() => Pad._(
    map((e) => e! as Map<String, Object?>)
      .map((e) => e.toDiode())
      .toList()
  );
}
