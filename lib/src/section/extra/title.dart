// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import 'string_type.dart';

final class Title implements Serializable {
  const Title._(this.title);

  final StringType title;

  @override
  List<int> toBytes() => title.toBytes();

  @override
  JsonList toJson() => title.toBytes().toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Title &&
    other.title == title;

  @override
  int get hashCode => title.hashCode;
}

extension TitleIterator on Iterator<int> {
  Title toTitle() => Title._(toStringType());
}

extension TitleList on List<int> {
  Title toTitle() => iterator.toTitle();
}
