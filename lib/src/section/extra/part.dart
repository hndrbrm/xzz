// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../../bytes_helper/list_helper.dart';
import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';
import 'content.dart';
import 'resistance_type.dart';
import 'text_type.dart';

sealed class Part<T> implements Bytesable, Jsonable {
  const Part(this.contents);

  final List<T> contents;

  @override
  bool operator ==(Object other) =>
    other is Part &&
    listEqual(other.contents, contents);

  @override
  int get hashCode => Object.hashAll(contents);
}

final class Part1<Content> extends Part {
  const Part1(super.contents);

  @override
  List<int> toBytes() => toJson().toBytes();

  @override
  JsonMap toJson() => {
    'part': contents
      .map((e) => e as Jsonable)
      .map((e) => e.toJson())
      .toList()
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Part1 &&
    listEqual(other.contents, contents);

  @override
  int get hashCode => Object.hashAll(contents);
}

final class Part2<ResistanceType> extends Part {
  const Part2(super.contents);

  @override
  List<int> toBytes() => [
    for (final content in contents)
    ...content.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'part': contents
      .map((e) => e as Jsonable)
      .map((e) => e.toJson())
      .toList()
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Part2 &&
    listEqual(other.contents, contents);

  @override
  int get hashCode => Object.hashAll(contents);
}

extension PartOnIterator on Iterator<int> {
  Part1 toPart1() {
    final json = toList().toString8();
    final map = jsonDecode(json) as Map<String, Object?>;

    return map.toPart1();
  }

  Part2 toPart2() {
    final items = <ResistanceType>[];
    for (;;) {
      try {
        final item = toTextType().toResistanceType();
        items.add(item);
      } on TextTypeNotFoundException {
        return Part2(items);
      }
    }
  }
}

extension PartOnList on List<int> {
  Part1 toPart1() => iterator.toPart1();

  Part2 toPart2() => iterator.toPart2();
}

extension PartOnMap on Map<String, Object?> {
  Part1 toPart1() => Part1(
    (this['part']! as List<Object?>)
      .map((e) => e! as Map<String, Object?>)
      .map((e) => e.toContent())
      .toList(),
  );

  Part2 toPart2() => Part2(
    (this['part']! as List<Object?>)
      .map((e) => e! as Map<String, Object?>)
      .map((e) => e.toResistanceType())
      .toList()
  );
}
