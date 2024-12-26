// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'text.dart';

class Textable with TextableMixin {
  const Textable._([ this._toText ]);

  @override
  final Text Function()? _toText;
}

mixin TextableMixin {
  Text Function()? get _toText;

  Text toText() =>
    _toText?.call() ??
    (throw UnimplementedError('$runtimeType'));
}

extension TextableOnString on Text {
  Textable toTextable() => Textable._(() => this);
}
