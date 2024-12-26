// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/text.dart';
import '../../serializable/textable.dart';
import 'resistance_type.dart';
import 'text_type.dart';

final class Resistance implements Bytesable, Jsonable, Textable {
  const Resistance._({
    required String value,
    required String part,
    required String pin,
  })
  : _value = value,
    _part = part,
    _pin = pin;

  final String _value;
  final String _part;
  final String _pin;

  @override
  Bytes toBytes() => toText().toTextType().toBytes();

  @override
  JsonMap toJson() => {
    'value': _value,
    'part': _part,
    'pin': _pin,
  }.toJsonMap();

  @override
  String toText() => '=$_value=$_part($_pin)';

  @override
  bool operator ==(Object other) =>
    other is Resistance &&
    _value == _value &&
    _part == _part &&
    _pin == _pin;

  @override
  int get hashCode => Object.hash(_value, _part, _pin);
}

extension ResistanceOnJson on Json {
  Resistance toResistance() => (this as JsonMap).toObject().toResistance();
}

extension ResistanceOnMap on Map<String, Object?> {
  Resistance toResistance() => Resistance._(
    value: this['value']! as String,
    part: this['part']! as String,
    pin: this['pin']! as String,
  );
}

extension ResistanceOnResistanceType on ResistanceType {
  Resistance toResistance() {
    final text = toText();
    final list = text.split('=');

    final value = list[1];
    final partPin = list[2];

    final start = partPin.indexOf('(');
    assert(start >= 0);

    final part = partPin.substring(0, start);
    final pin = partPin.substring(start, partPin.length - 1);
    assert(partPin[partPin.length - 1] == ')');

    return Resistance._(
      value: value,
      part: part,
      pin: pin,
    );
  }
}
