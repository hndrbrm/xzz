// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import 'pad.dart';

final class Content implements Bytesable, Jsonable {
  const Content._({
    required this.reference,
    required this.pad,
  });

  final String reference;
  final Pad pad;

  @override
  Bytes toBytes() => toJson().toBytes();

  @override
  JsonMap toJson() => {
    'reference': reference,
    'pad': pad.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Content &&
    other.reference == reference &&
    other.pad == pad;

  @override
  int get hashCode => Object.hash(
    reference,
    pad,
  );
}

extension ContentOnMap on Map<String, Object?> {
  Content toContent() => Content._(
    reference: this['reference']! as String,
    pad: (this['pad']! as List<Object?>).toPad(),
  );
}
