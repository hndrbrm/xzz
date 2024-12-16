// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../bytes_helper/string_helper.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';

final class Signature implements Serializable {
  const Signature._(this.id);

  final String id;

  @override
  List<int> toBytes() => id.toString8List();

  @override
  JsonList toJson() => id.toString8List().toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Signature &&
    other.id == id;

  @override
  int get hashCode => id.hashCode;
}

final class InvalidSignatureException implements Exception {}

extension SignatureIterator on Iterator<int> {
  static const _id = 'v6v6555v6v6';

  Signature toSignature() {
    final id = read(_id.length).toString8();
    if (id != _id) {
      throw InvalidSignatureException();
    }

    return Signature._(id);
  }
}

extension SignatureList on List<int> {
  static const _marker = 'v6v6555v6v6';

  int findSignature() => _findMarker(this, _marker.toString8List());

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
