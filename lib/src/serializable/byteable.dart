// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

class Bytesable {
  Bytesable(this._toBytes);

  final List<int> Function() _toBytes;

  List<int> toBytes() => _toBytes();
}

extension ByteableList on List<int> {
  Bytesable toBytesable() => Bytesable(() => this);
}
