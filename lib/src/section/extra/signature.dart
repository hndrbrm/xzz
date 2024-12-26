// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/list_helper.dart';
import '../../bytes_helper/string_helper.dart';
import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';

sealed class Signature implements Bytesable, Jsonable {
  const Signature(this.id);

  final List<int> id;

  @override
  List<int> toBytes() => id;

  @override
  JsonList toJson() => id.toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Signature &&
    other.id == id;

  @override
  int get hashCode => id.hashCode;
}

final class Signature1 extends Signature {
  const Signature1(super.id);

  @override
  bool operator ==(Object other) =>
    other is Signature1 &&
    other.id == id;

  @override
  int get hashCode => id.hashCode;
}

final class Signature2 extends Signature {
  const Signature2(super.id);

  @override
  bool operator ==(Object other) =>
    other is Signature2 &&
    other.id == id;

  @override
  int get hashCode => id.hashCode;
}

final class InvalidSignatureException implements Exception {}

extension SignatureIterator on Iterator<int> {
}

extension SignatureList on List<int> {
  static const _marker = 'v6v6555v6v6';

  int signaturePosition() => _findMarker(
    this,
    _marker.toString8List(),
  );

  Signature toSignature() {
    const length = _marker.length;
    final id = sublist(0, length);

    if (id.toString8() == _marker) {
      if (this[length] == 0x0a) {
        return Signature1([ ...id, 0x0a ]);
      } else {
        return Signature2(id);
      }
    }

    throw InvalidSignatureException();
  }

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
