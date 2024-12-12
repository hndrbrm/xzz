// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

class Byteable {
  Byteable(this._toBytes);

  final List<int> Function() _toBytes;

  List<int> toByte() => _toBytes();
}

extension ByteableList on List<int> {
  Byteable toByteable() => Byteable(() => this);
}
