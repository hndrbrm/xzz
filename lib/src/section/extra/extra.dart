// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import 'signature.dart';
import 'title.dart';

final class Extra implements Serializable {
  const Extra._({
    required this.signature,
    required this.title,
    required this.rest,
  });

  final Signature signature;
  final Title title;
  final List<int> rest;

  @override
  List<int> toBytes() => [
    ...signature.toBytes(),
    ...title.toBytes(),
    ...rest,
  ];

  @override
  JsonMap toJson() => {
    'signature': signature.toJson(),
    'title': title.toJson(),
    'rest': rest,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Extra &&
    other.signature == signature &&
    other.title == title &&
    listEqual(other.rest, rest);

  @override
  int get hashCode => Object.hash(
    signature,
    title,
    Object.hashAll(rest),
  );
}

extension ExtraIterator on Iterator<int> {
  Extra toExtra() => Extra._(
    signature: toSignature(),
    title: toTitle(),
    rest: toList(),
  );
}

extension ExtraList on List<int> {
  Extra toExtra() => iterator.toExtra();
}

extension ExtraMap on Map<String, Object?> {
  Extra toExtra() => Extra._(
    signature: (this['signature']! as List<Object?>).toBytes().toSignature(),
    title: (this['title']! as List<Object?>).toBytes().toTitle(),
    rest: (this['rest']! as List<Object?>).toBytes()
  );
}
