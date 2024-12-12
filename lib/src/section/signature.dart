// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../bytes_helper/iterator_helper.dart';
import '../bytes_helper/list_helper.dart';
import '../bytes_helper/string_helper.dart';
import '../serializable.dart';

final class Signature implements Serializable {
  const Signature._(this.id);

  final String id;

  @override
  List<int> toByte() => id.toString8List();

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
  };
}

final class InvalidSignatureException extends FormatException {}

extension SignatureIterator on Iterator<int> {
  static const String _id = 'XZZPCB V1.0';

  Signature toSignature() {
    final id = read(11).toString8();

    if (id != _id) {
      throw InvalidSignatureException();
    }

    return Signature._(id);
  }
}

extension SignatureMap on Map<String, dynamic> {
  Signature toSignature() => Signature._(this['id']);
}
