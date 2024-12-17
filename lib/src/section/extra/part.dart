// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../../bytes_helper/list_helper.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/serializable.dart';
import 'content.dart';

final class Part implements Serializable {
  const Part._(this.contents);

  final List<Content> contents;

  @override
  List<int> toBytes() => toJson().toBytes();

  @override
  JsonMap toJson() => {
    'part': contents.map((e) => e.toJson()).toList()
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Part &&
    listEqual(other.contents, contents);

  @override
  int get hashCode => Object.hashAll(contents);
}

extension PartIterator on Iterator<int> {
  Part toPart() {
    final json = toList().toString8();
    final map = jsonDecode(json) as Map<String, Object?>;

    return map.toPart();
  }
}

extension PartList on List<int> {
  Part toPart() => iterator.toPart();
}

extension PartMap on Map<String, Object?> {
  Part toPart() => Part._(
    (this['part']! as List<Object?>)
      .map((e) => e! as Map<String, Object?>)
      .map((e) => e.toContent())
      .toList(),
  );
}
