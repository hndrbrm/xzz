// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'bytes.dart';
import 'jsonable.dart';

class Bytesable with BytesableMixin {
  const Bytesable([ this._toBytes ]);

  @override
  final Bytes Function()? _toBytes;
}

mixin BytesableMixin {
  Bytes Function()? get _toBytes;

  Bytes toBytes() =>
    _toBytes?.call() ??
    (throw UnimplementedError('$runtimeType'));
}

extension BytesableOnBytes on Bytes {
  Bytesable toBytesable() => Bytesable(() => this);
}

extension BytesableOnList on List<Object?> {
  Bytesable toBytesable() => toBytes().toBytesable();
}
