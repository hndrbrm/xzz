// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import 'pad.dart';

final class Content implements Bytesable, Jsonable {
  const Content._({
    required String reference,
    required Pad pad,
  })
  : _reference = reference,
    _pad = pad;

  final String _reference;
  final Pad _pad;

  @override
  Bytes toBytes() => toJson().toBytes();

  @override
  JsonMap toJson() => {
    'reference': _reference,
    'pad': _pad.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Content &&
    other._reference == _reference &&
    other._pad == _pad;

  @override
  int get hashCode => Object.hash(
    _reference,
    _pad,
  );
}

extension ContentOnMap on Map<String, Object?> {
  Content toContent() => Content._(
    reference: this['reference']! as String,
    pad: (this['pad']! as List<Object?>).toPad(),
  );
}
