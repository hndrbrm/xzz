// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';

final class Diode implements Bytesable, Jsonable {
  const Diode._({
    required String name,
    required String value,
  })
  : _name = name,
    _value = value;

  final String _name;
  final String _value;

  @override
  Bytes toBytes() => toJson().toBytes();

  @override
  JsonMap toJson() => {
    'name': _name,
    'diode': _value,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Diode &&
    other._name == _name &&
    other._value == _value;

  @override
  int get hashCode => Object.hash(
    _name,
    _value,
  );
}

extension DiodeOnMap on Map<String, Object?> {
  Diode toDiode() => Diode._(
    name: this['name']! as String,
    value: this['diode']! as String,
  );
}
