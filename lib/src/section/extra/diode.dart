// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';

final class Diode implements Bytesable, Jsonable {
  const Diode._({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  @override
  Bytes toBytes() => toJson().toBytes();

  @override
  JsonMap toJson() => {
    'name': name,
    'diode': value,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Diode &&
    other.name == name &&
    other.value == value;

  @override
  int get hashCode => Object.hash(
    name,
    value,
  );
}

extension DiodeOnMap on Map<String, Object?> {
  Diode toDiode() => Diode._(
    name: this['name']! as String,
    value: this['diode']! as String,
  );
}
