// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/textable.dart';
import 'resistance_type.dart';
import 'text.dart';
import 'text_type.dart';

final class Resistance implements Bytesable, Jsonable, Textable {
  const Resistance({
    required this.value,
    required this.part,
    required this.pin,
  });

  final String value;
  final String part;
  final String pin;

  @override
  List<int> toBytes() => toText().toTextType().toBytes();

  @override
  JsonMap toJson() => {
    'value': value,
    'part': part,
    'pin': pin,
  }.toJsonMap();

  @override
  String toText() => '=$value=$part($pin)';

  @override
  bool operator ==(Object other) =>
    other is Resistance &&
    value == value &&
    part == part &&
    pin == pin;

  @override
  int get hashCode => Object.hash(value, part, pin);
}

extension ResistanceOnJson on Json {
  Resistance toResistance() => (this as JsonMap).toObject().toResistance();
}

extension ResistanceOnMap on Map<String, Object?> {
  Resistance toResistance() => Resistance(
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

    return Resistance(
      value: value,
      part: part,
      pin: pin,
    );
  }
}
