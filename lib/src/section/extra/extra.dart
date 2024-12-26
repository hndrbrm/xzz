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
    required this.signature,
    required this.title,
    required this.part,
  });

  final ExtraSignature signature;
  final Title title;
  final Part part;

  @override
  Bytes toBytes() => [
    ...signature.toBytes(),
    ...title.toBytes(),
    ...part.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'signature': signature.toJson(),
    'title': title.toJson(),
    'part': part.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Extra &&
    other.signature == signature &&
    other.title == title &&
    other.part == part;

  @override
  int get hashCode => Object.hash(
    signature,
    title,
    part,
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
