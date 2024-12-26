// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../bytes_helper/string_helper.dart';
import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';

final class Signature implements Bytesable, Jsonable {
  const Signature._(this.id);

  final String id;

  @override
  List<int> toBytes() => id.toString8List();

  @override
  JsonMap toJson() => { 'id': id }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Signature &&
    other.id == id;

  @override
  int get hashCode => id.hashCode;
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

extension SignatureJsonMap on JsonMap {
  Signature toSignature() => toObject().toSignature();
}

extension SignatureMap on Map<String, Object?> {
  Signature toSignature() => Signature._(this['id']! as String);
}
