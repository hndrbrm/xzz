// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'jsonable.dart';

class Bytesable with BytesableMixin {
  const Bytesable([ this._toBytes ]);

  @override
  final List<int> Function()? _toBytes;
}

mixin BytesableMixin {
  List<int> Function()? get _toBytes;

  List<int> toBytes() =>
    _toBytes?.call() ??
    (throw UnimplementedError('$runtimeType'));
}

extension ByteableList on List<int> {
  Bytesable toBytesable() => Bytesable(() => this);
}

extension ListExtension on List<Object?> {
  Bytesable toBytesable() => toBytes().toBytesable();
}
