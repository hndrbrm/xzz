// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../bytes_helper/string_helper.dart';
import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';

final class PcbSignature implements Bytesable, Jsonable {
  const PcbSignature._(this._id);

  final String _id;

  @override
  List<int> toBytes() => _id.toString8List();

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

extension PcbSignatureOnIterator on Iterator<int> {
  static const String _id = 'XZZPCB V1.0';

  PcbSignature toPcbSignature() {
    final id = read(11).toString8();

    if (id != _id) {
      throw InvalidPcbSignatureException();
    }

    return PcbSignature._(id);
  }
}

extension PcbSignatureOnList on List<int> {
  PcbSignature toPcbSignature() => iterator.toPcbSignature();
}

extension PcbSignatureOnJsonMap on JsonMap {
  PcbSignature toPcbSignature() => toObject().toPcbSignature();
}

extension PcbSignatureOnMap on Map<String, Object?> {
  PcbSignature toPcbSignature() => PcbSignature._(this['id']! as String);
}
