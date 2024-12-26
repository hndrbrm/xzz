// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

class Textable with TextableMixin {
  const Textable([ this._toText ]);

  @override
  final String Function()? _toText;
}

mixin TextableMixin {
  String Function()? get _toText;

  String toText() =>
    _toText?.call() ??
    (throw UnimplementedError('$runtimeType'));
}

extension ByteableList on String {
  Textable toTextable() => Textable(() => this);
}
