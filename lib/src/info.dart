// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:dart_des/dart_des.dart';

import 'shareable/int_helper.dart';
import 'shareable/iterator_helper.dart';
import 'shareable/list_helper.dart';
import 'shareable/serializer.dart';

final class InfoContainer implements Serializer<List<int>>{
  const InfoContainer(this.info);

  factory InfoContainer.deserialize(Iterator<int> iterator) {
    final (type, content) = iterator.dewrapWithId();

    final contentIterator = content.iterator;

    final info = switch (type) {
      ArcInfo.id => ArcInfo.deserialize(contentIterator),
      LineInfo.id => LineInfo.deserialize(contentIterator),
      ViaInfo.id => ViaInfo.deserialize(contentIterator),
      PartInfo.id => PartInfo.deserialize(content),
      _ => throw UnimplementedError('$type'),
    };

    return InfoContainer(info);
  }

  final Info info;

  @override
  List<int> serialize() => info.serialize().wrapWithId(info.type);
}

sealed class Info implements Serializer<List<int>> {
  int get type;
}

// final class Info implements Serializer {
//   const Info({
//     required this.type,
//     required this.bytes,
//   });
//
//   factory Info.deserialize(Iterator<int> iterator) {
//     final type = iterator.read(1).first;
//     final length = iterator.read(4).toUint32();
//     final content = iterator.read(length);
//
//     return Info(
//       type: type,
//       bytes: content,
//     );
//   }
//
//   final int type;
//   final List<int> bytes;
//
//   @override
//   List<int> serialize() => [
//     type,
//     ...bytes.length.toUint32List(),
//     ...bytes,
//   ];
// }

final class ArcInfo implements Info {
  ArcInfo.deserialize(Iterator<int> iterator)
  : layer = iterator.read(4).toUint32(),
    x = iterator.read(4).toUint32(),
    y = iterator.read(4).toUint32(),
    r = iterator.read(4).toUint32(),
    startAngle = iterator.read(4).toUint32(),
    endAngle = iterator.read(4).toUint32(),
    scale = iterator.read(4).toUint32(),
    unknown = iterator.read(4).toUint32();

  final int layer;
  final int x;
  final int y;
  final int r;
  final int startAngle;
  final int endAngle;
  final int scale;
  final int unknown;

  static const id = 1;

  @override
  int get type => id;

  @override
  List<int> serialize() => [
    ...layer.toUint32List(),
    ...x.toUint32List(),
    ...y.toUint32List(),
    ...r.toUint32List(),
    ...startAngle.toUint32List(),
    ...endAngle.toUint32List(),
    ...scale.toUint32List(),
    ...unknown.toUint32List(),
  ];
}

final class ViaInfo implements Info {
  ViaInfo.deserialize(Iterator<int> iterator)
  : raw = iterator.read(32);

  final List<int> raw;

  static const id = 2;

  @override
  int get type => id;

  @override
  List<int> serialize() => raw;
}

final class LineInfo implements Info {
  LineInfo.deserialize(Iterator<int> iterator)
  : layer = iterator.read(4).toUint32(),
    x1 = iterator.read(4).toUint32(),
    y1 = iterator.read(4).toUint32(),
    x2 = iterator.read(4).toUint32(),
    y2 = iterator.read(4).toUint32(),
    scale = iterator.read(4).toUint32(),
    traceNetIndex = iterator.read(4).toUint32();

  final int layer;
  final int x1;
  final int y1;
  final int x2;
  final int y2;
  final int scale;
  final int traceNetIndex;

  static const id = 5;

  @override
  int get type => id;

  @override
  List<int> serialize() => [
    ...layer.toUint32List(),
    ...x1.toUint32List(),
    ...y1.toUint32List(),
    ...x2.toUint32List(),
    ...y2.toUint32List(),
    ...scale.toUint32List(),
    ...traceNetIndex.toUint32List(),
  ];
}

final class PartInfo implements Info {
  const PartInfo._({
    required this.unknown1,
    required this.description,
    required this.unknown2,
    required this.name,
    required this.parts,
  });

  factory PartInfo.deserialize(List<int> list) {
    final plain = _des.decrypt(list);
    final iterator1 = plain.iterator;

    var offset = 0;

    final length = iterator1.read(4).toUint32();
    final content = iterator1.read(length);
    final iterator2 = content.iterator;
    offset += 4;

    final unknown1 = iterator2.read(18);
    final descriptionLength = iterator2.read(4).toUint32();
    final description = iterator2.read(descriptionLength).toString8();
    final unknown2 = iterator2.read(31);
    final nameLength = iterator2.read(4).toUint32();
    final name = iterator2.read(nameLength).toString8();
    offset += 18 + 4 + descriptionLength + 31 + 4 + nameLength;

    final parts = <Part>[];

    for (; offset < length; ) {
      final container = PartContainer.deserialize(iterator2);
      parts.add(container.part);
      offset += container.serialize().length;
    }

    return PartInfo._(
      unknown1: unknown1,
      description: description,
      unknown2: unknown2,
      name: name,
      parts: parts,
    );
  }

  final List<int> unknown1;
  final String description;
  final List<int> unknown2;
  final String name;
  final List<Part> parts;

  static const int id = 7;

  static final _des = DES(
    key: [ 0xdc, 0xfc, 0x12, 0xac, 0x00, 0x00, 0x00, 0x00 ],
    paddingType: DESPaddingType.None,
  );

  List<int> _fillWithZero(List<int> list) {
    final remainder = 8 - (list.length % 8);
    return [
      ...list,
      if (remainder < 8)
      ...List.filled(remainder, 0),
    ];
  }

  @override
  int get type => id;

  @override
  List<int> serialize() {
    final bytes = [
      ...unknown1,
      ...description.length.toUint32List(),
      ...utf8.encode(description),
      ...unknown2,
      ...name.length.toUint32List(),
      ...utf8.encode(name),
      for (final part in parts)
      ...PartContainer._(part).serialize(),
    ].wrap();

    return _des.encrypt(_fillWithZero(bytes));
  }
}

sealed class Part implements Serializer<List<int>> {
  int get type;
}

final class UnknownPart1 implements Part {
  const UnknownPart1.deserialize(this.raw);

  final List<int> raw;

  static const id = 1;

  @override
  int get type => id;

  @override
  List<int> serialize() => raw;
}

final class LinePart implements Part {
  const LinePart.deserialize(this.raw);

  final List<int> raw;

  static const id = 5;

  @override
  int get type => id;

  @override
  List<int> serialize() => raw;
}

final class LabelPart implements Part {
  const LabelPart.deserialize(this.raw);

  final List<int> raw;

  static const id = 6;

  @override
  int get type => id;

  @override
  List<int> serialize() => raw;
}

final class PinPart implements Part {
  const PinPart._({
    required this.unknown1,
    required this.x,
    required this.y,
    required this.unknown2,
    required this.name,
    required this.unknown3,
    required this.netIndex,
    required this.unknown4,
  });

  factory PinPart.deserialize(Iterator<int> iterator) {
    final unknown1 = iterator.read(4).toUint32();
    final x = iterator.read(4).toUint32();
    final y = iterator.read(4).toUint32();
    final unknown2 = iterator.read(8);
    final nameLength = iterator.read(4).toUint32();
    final name = iterator.read(nameLength).toString8();
    final unknown3 = iterator.read(32);
    final netIndex = iterator.read(4).toUint32();
    final unknown4 = iterator.read(8);

    return PinPart._(
      unknown1: unknown1,
      x: x,
      y: y,
      unknown2: unknown2,
      name: name,
      unknown3: unknown3,
      netIndex: netIndex,
      unknown4: unknown4,
    );
  }

  final int unknown1;
  final int x;
  final int y;
  final List<int> unknown2;
  final String name;
  final List<int> unknown3;
  final int netIndex;
  final List<int> unknown4;

  static const id = 9;

  @override
  int get type => id;

  @override
  List<int> serialize() => [
    ...unknown1.toUint32List(),
    ...x.toUint32List(),
    ...y.toUint32List(),
    ...unknown2,
    ...name.length.toUint32List(),
    ...utf8.encode(name),
    ...unknown3,
    ...netIndex.toUint32List(),
    ...unknown4,
  ];
}

final class PartContainer implements Serializer<List<int>> {
  const PartContainer._(this.part);

  factory PartContainer.deserialize(Iterator<int> iterator) {
    final (type, content) = iterator.dewrapWithId();
    final contentIterator = content.iterator;

    final part = switch (type) {
      UnknownPart1.id => UnknownPart1.deserialize(content),
      LinePart.id => LinePart.deserialize(content),
      LabelPart.id => LabelPart.deserialize(content),
      PinPart.id => PinPart.deserialize(contentIterator),
      _ => throw UnimplementedError('$type'),
    };

    return PartContainer._(part);
  }

  final Part part;

  @override
  List<int> serialize() => part.serialize().wrapWithId(part.type);
}

extension on Iterator<int> {
  (int, List<int>) dewrapWithId() {
    final id = read(1).first;
    final content = dewrap();

    return (id, content);
  }

  List<int> dewrap() {
    final length = read(4).toUint32();
    final content = read(length);
    return content;
  }
}

extension on List<int> {
  List<int> wrapWithId(int id) => [
    id,
    ...wrap(),
  ];

  List<int> wrap() => [
    ...length.toUint32List(),
    ...this,
  ];
}
