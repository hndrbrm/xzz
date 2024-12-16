// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'section/extra/extra.dart';
import 'section/extra/signature.dart';
import 'section/pcb/pcb.dart';
import 'serializable/jsonable.dart';
import 'serializable/serializable.dart';

final class Xzz implements Serializable {
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

extension XzzList on List<int> {
  Xzz toXzz() {
    final position = findSignature();

    if (position == -1) {
      return Xzz._(
        pcb: iterator.toPcb(),
      );
    }

    return Xzz._(
      pcb: iterator.toPcb(),
      extra: sublist(position).toExtra(),
    );
  }
}

extension XzzMap on Map<String, Object?> {
  Xzz toXzz() => Xzz._(
    pcb: (this['pcb']! as Map<String, Object?>).toPcb(),
    extra: (this['extra'] as Map<String, Object?>?)?.toExtra(),
  );
}
