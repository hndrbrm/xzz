// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/text.dart';

final class PcbSignature implements Bytesable, Jsonable {
  const PcbSignature._(this._id);

  final String _id;

  @override
  Bytes toBytes() => _id.toBytes();

  @override
  JsonMap toJson() => { 'id': _id }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is PcbSignature &&
    other._id == _id;

  @override
  int get hashCode => _id.hashCode;
}

final class InvalidPcbSignatureException extends FormatException {}

extension PcbSignatureOnBytes on Bytes {
  PcbSignature toPcbSignature() => iterator.toPcbSignature();
}

extension PcbSignatureOnIterator on Iterator<int> {
  static const String _id = 'XZZPCB V1.0';

  PcbSignature toPcbSignature() {
    final id = read(11).toText();

    if (id != _id) {
      throw InvalidPcbSignatureException();
    }

    return PcbSignature._(id);
  }
}

extension PcbSignatureOnJsonMap on JsonMap {
  PcbSignature toPcbSignature() => toObject().toPcbSignature();
}

extension PcbSignatureOnMap on Map<String, Object?> {
  PcbSignature toPcbSignature() => PcbSignature._(this['id']! as String);
}
