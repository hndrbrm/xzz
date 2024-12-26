// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import 'extra_signature.dart';
import 'part.dart';
import 'title.dart';

final class Extra implements Bytesable, Jsonable {
  const Extra._({
    required ExtraSignature signature,
    required Title title,
    required Part<dynamic> part,
  })
  : _signature = signature,
    _title = title,
    _part = part;

  final ExtraSignature _signature;
  final Title _title;
  final Part _part;

  @override
  Bytes toBytes() => [
    ..._signature.toBytes(),
    ..._title.toBytes(),
    ..._part.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'signature': _signature.toJson(),
    'title': _title.toJson(),
    'part': _part.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Extra &&
    other._signature == _signature &&
    other._title == _title &&
    other._part == _part;

  @override
  int get hashCode => Object.hash(
    _signature,
    _title,
    _part,
  );
}

extension ExtraOnBytes on Bytes {
  Extra toExtra() {
    final signature = toExtraSignature();
    final rest = sublist(signature.toBytes().length).iterator;

    final title = rest.toTitle();
    final part = switch (signature) {
      Signature1() => rest.toPart1(),
      Signature2() => rest.toPart2(),
    };

    return Extra._(
      signature: signature,
      title: title,
      part: part,
    );
  }
}

extension ExtraOnMap on Map<String, Object?> {
  Extra toExtra() {
    final signature = (this['signature']! as List<Object?>)
      .toBytes()
      .toExtraSignature();

    final partMap = this['part']! as Map<String, Object?>;
    final part = switch (signature) {
      Signature1() => partMap.toPart1(),
      Signature2() => partMap.toPart2(),
    };

    return Extra._(
      signature: signature,
      title: (this['title']! as List<Object?>).toBytes().toTitle(),
      part: part,
    );
  }
}
