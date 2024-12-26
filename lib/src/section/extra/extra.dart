// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';
import 'part.dart';
import 'signature.dart';
import 'title.dart';

final class Extra implements Bytesable, Jsonable {
  const Extra._({
    required this.signature,
    required this.title,
    required this.part,
  });

  final Signature signature;
  final Title title;
  final Part part;

  @override
  List<int> toBytes() => [
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

extension ExtraList on List<int> {
  Extra toExtra() {
    final signature = toSignature();
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

extension ExtraMap on Map<String, Object?> {
  Extra toExtra() {
    final signature = (this['signature']! as List<Object?>)
      .toBytes()
      .toSignature();

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
