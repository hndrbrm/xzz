// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/text.dart';

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

final class ExtraSignature1 extends ExtraSignature {
  const ExtraSignature1(super._id);

  @override
  bool operator ==(Object other) =>
    other is ExtraSignature1 &&
    listEqual(other._id, _id);

  @override
  int get hashCode => _id.hashCode;
}

final class ExtraSignature2 extends ExtraSignature {
  const ExtraSignature2(super._id);

  @override
  bool operator ==(Object other) =>
    other is ExtraSignature2 &&
    listEqual(other._id, _id);

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

    if (id.toText() == _marker) {
      if (this.length > length && this[length] == 0x0a) {
        return ExtraSignature1([ ...id, 0x0a ]);
      } else {
        return ExtraSignature2(id);
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

extension ExtraSignatureOnJsonList on JsonList {
  ExtraSignature toExtraSignature() {
    final id = toObject().toBytes();
    return id.last == 0x0a ? ExtraSignature1(id) : ExtraSignature2(id);
  }
}
