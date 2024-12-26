// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';

sealed class ExtraSignature implements Bytesable, Jsonable {
  const ExtraSignature(this._id);

  final Bytes _id;

  @override
  Bytes toBytes() => _id;

  @override
  JsonList toJson() => _id.toJsonList();

  @override
  bool operator ==(Object other) =>
    other is ExtraSignature &&
    other._id == _id;

  @override
  int get hashCode => _id.hashCode;
}

final class Signature1 extends ExtraSignature {
  const Signature1(super._id);

  @override
  bool operator ==(Object other) =>
    other is Signature1 &&
    other._id == _id;

  @override
  int get hashCode => _id.hashCode;
}

final class Signature2 extends ExtraSignature {
  const Signature2(super._id);

  @override
  bool operator ==(Object other) =>
    other is Signature2 &&
    other._id == _id;

  @override
  int get hashCode => _id.hashCode;
}

final class InvalidExtraSignatureException implements Exception {}

extension ExtraSignatureOnBytes on Bytes {
  static const _marker = 'v6v6555v6v6';

  int signaturePosition() => _findMarker(
    this,
    _marker.toBytes(),
  );

  ExtraSignature toExtraSignature() {
    const length = _marker.length;
    final id = sublist(0, length);

    if (id.toString8() == _marker) {
      if (this.length > length && this[length] == 0x0a) {
        return Signature1([ ...id, 0x0a ]);
      } else {
        return Signature2(id);
      }
    }

    throw InvalidExtraSignatureException();
  }

  int _findMarker(Bytes content, Bytes marker) {
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
