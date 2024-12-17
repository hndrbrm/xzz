// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import 'string_type.dart';

final class Signature implements Serializable {
  const Signature._(this.id);

  final StringType id;

  @override
  List<int> toBytes() => id.toBytes();

  @override
  JsonList toJson() => id.toBytes().toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Signature &&
    other.id == id;

  @override
  int get hashCode => id.hashCode;
}

final class InvalidSignatureException implements Exception {}

extension SignatureIterator on Iterator<int> {
  static const _id = StringType('v6v6555v6v6');

  Signature toSignature() {
    final id = toStringType();
    if (id != _id) {
      throw InvalidSignatureException();
    }

    return Signature._(id);
  }
}

extension SignatureList on List<int> {
  int findSignature() => _findMarker(this, SignatureIterator._id.toBytes());

  Signature toSignature() => iterator.toSignature();

  int _findMarker(List<int> content, List<int> marker) {
    for (var i = 0; i <= content.length - marker.length; i++) {
      var found = true;

      for (var j = 0; j < marker.length; j++) {
        if (content[i + j] != marker[j]) {
          found = false;
          break;
        }
      }

      if (found) {
        return i;
      }
    }

    return -1;
  }
}
