// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'section/extra/extra.dart';
import 'section/pcb/pcb.dart';
import 'serializable/bytes.dart';
import 'serializable/bytesable.dart';
import 'serializable/jsonable.dart';

final class Xzz implements Bytesable, Jsonable {
  const Xzz._({
    required Pcb pcb,
    Extra? extra,
  })
  : _pcb = pcb,
    _extra = extra;

  final Pcb _pcb;
  final Extra? _extra;

  @override
  Bytes toBytes() => [
    ..._pcb.toBytes(),
    if (_extra != null)
    ..._extra!.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'pcb': _pcb.toJson(),
    if (_extra != null)
    'extra': _extra!.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Xzz &&
    other._pcb == _pcb &&
    other._extra == _extra;

  @override
  int get hashCode => Object.hash(
    _pcb,
    _extra,
  );
}

extension XzzOnBytes on Bytes {
  Xzz toXzz() => iterator.toXzz();
}

extension XzzOnIterator on Iterator<int> {
  Xzz toXzz() {
    final pcb = toPcb();

    final list = toBytes();
    final extra = list.isEmpty ? null : list.toExtra();

    return Xzz._(
      pcb: pcb,
      extra: extra,
    );
  }
}

extension XzzOnJsonMap on JsonMap {
  Xzz toXzz() => toObject().toXzz();
}

extension XzzOnMap on Map<String, Object?> {
  Xzz toXzz() => Xzz._(
    pcb: (this['pcb']! as Map<String, Object?>).toPcb(),
    extra: (this['extra'] as Map<String, Object?>?)?.toExtra(),
  );
}
