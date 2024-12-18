// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import 'pad.dart';
import 'part.dart';
import 'signature.dart';
import 'title.dart';

final class Extra implements Serializable {
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

    return Extra._(
      signature: signature,
      title: rest.toTitle(),
      part: rest.toPart(),
    );
  }
}

extension ExtraMap on Map<String, Object?> {
  Extra toExtra() => Extra._(
    signature: (this['signature']! as List<Object?>).toBytes().toSignature(),
    title: (this['title']! as List<Object?>).toBytes().toTitle(),
    part: (this['part']! as Map<String, Object?>).toPart(),
  );
}
