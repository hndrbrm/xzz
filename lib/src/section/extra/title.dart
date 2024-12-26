// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import 'text_type.dart';

final class Title implements Bytesable, Jsonable {
  const Title._(this._title);

  final TextType _title;

  @override
  Bytes toBytes() => _title.toBytes();

  @override
  JsonList toJson() => _title.toBytes().toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Title &&
    other._title == _title;

  @override
  int get hashCode => _title.hashCode;
}

extension TitleOnBytes on Bytes {
  Title toTitle() => iterator.toTitle();
}

extension TitleOnIterator on Iterator<int> {
  Title toTitle() => Title._(toTextType());
}
