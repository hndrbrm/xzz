// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

class Mappable {
  Mappable._(this._toMap);

  final Map<String, dynamic> Function() _toMap;

  Map<String, dynamic> toMap() => _toMap();
}

extension MappableMap on Map<String, dynamic> {
  Mappable toMappable() => Mappable._(() => this);
}
