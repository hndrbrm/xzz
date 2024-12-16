// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import 'signature.dart';

final class Extra implements Serializable {
  const Extra._({
    required this.signature,
    required this.rest,
  });

  final Signature signature;
  final List<int> rest;

  @override
  List<int> toBytes() => [
    ...signature.toBytes(),
    ...rest,
  ];

  @override
  JsonMap toJson() => {
    'signature': signature.toJson(),
    'rest': rest,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Extra &&
    other.signature == signature &&
    listEqual(other.rest, rest);

  @override
  int get hashCode => Object.hash(
    signature,
    Object.hashAll(rest),
  );
}

extension ExtraList on List<int> {
  Extra toExtra() {
    final signature = toSignature();
    final rest = sublist(signature.toBytes().length);

    return Extra._(
      signature: signature,
      rest: rest,
    );
  }
}

extension ExtraMap on Map<String, Object?> {
  Extra toExtra() => Extra._(
    signature: (this['signature']! as List<Object?>).toBytes().toSignature(),
    rest: (this['rest']! as List<Object?>).toBytes()
  );
}
