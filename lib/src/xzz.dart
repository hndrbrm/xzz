// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'bytes_helper/list_helper.dart';
import 'section/extra/extra.dart';
import 'section/pcb/pcb.dart';
import 'serializable/byteable.dart';
import 'serializable/jsonable.dart';

final class Xzz implements Bytesable, Jsonable {
  const Xzz._({
    required this.pcb,
    this.extra,
  });

  final Pcb pcb;
  final Extra? extra;

  @override
  List<int> toBytes() => [
    ...pcb.toBytes(),
    if (extra != null)
    ...extra!.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'pcb': pcb.toJson(),
    if (extra != null)
    'extra': extra!.toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Xzz &&
    other.pcb == pcb &&
    other.extra == extra;

  @override
  int get hashCode => Object.hash(
    pcb,
    extra,
  );
}

extension XzzJsonMap on JsonMap {
  Xzz toXzz() => toObject().toXzz();
}

extension XzzIterator on Iterator<int> {
  Xzz toXzz() {
    final pcb = toPcb();

    final list = toList();
    final extra = list.isEmpty ? null : list.toExtra();

    return Xzz._(
      pcb: pcb,
      extra: extra,
    );
  }
}

extension XzzList on List<int> {
  Xzz toXzz() => iterator.toXzz();
}

extension XzzMap on Map<String, Object?> {
  Xzz toXzz() => Xzz._(
    pcb: (this['pcb']! as Map<String, Object?>).toPcb(),
    extra: (this['extra'] as Map<String, Object?>?)?.toExtra(),
  );
}
