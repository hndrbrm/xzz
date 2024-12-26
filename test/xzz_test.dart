// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:test/test.dart';
import 'package:xzz/xzz.dart';

void main() {
  late PcbBytes withExtra1;
  late PcbBytes withExtra2;
  late PcbBytes noExtra;

  setUp(() {
    withExtra1 = PcbBytes.loadExtra1();
    withExtra2 = PcbBytes.loadExtra2();
    noExtra = PcbBytes.loadNoExtra();
  });

  test('PcbSignature', () {
    final signature = noExtra.pcbSignature.toPcbSignature();
    expect(signature.toBytes(), equals(noExtra.pcbSignature));
  });

  test('Offset', () {
    final offset = noExtra.offset.toOffset();
    expect(offset.toBytes(), equals(noExtra.offset));
  });

  test('Segments', () {
    final segments = noExtra.segments.toSegments();
    expect(segments.toBytes(), equals(noExtra.segments));
  });

  test('Images', () {
    final images = noExtra.images.toImages();
    expect(images.toBytes(), equals(noExtra.images));
  });

  test('Nets', () {
    final nets = noExtra.nets.toNets();
    expect(nets.toBytes(), equals(noExtra.nets));
  });

  test('Pcb', () {
    final pcb = noExtra.pcb.toPcb();
    expect(pcb.toBytes(), equals(noExtra.pcb));
  });

  test('ExtraSignature', () {
    final signature1 = withExtra1.extraSignature!.toExtraSignature();
    expect(signature1.toBytes(), equals(withExtra1.extraSignature));

    final signature2 = withExtra2.extraSignature!.toExtraSignature();
    expect(signature2.toBytes(), equals(withExtra2.extraSignature));
  });

  test('Title', () {
    final title = withExtra1.title!.toTitle();
    expect(title.toBytes(), equals(withExtra1.title));
  });

  test('Part', () {
    final part1 = withExtra1.part!.toPart1();
    expect(part1.toBytes(), equals(withExtra1.part));

    final part2 = withExtra2.part!.toPart2();
    expect(part2.toBytes(), equals(withExtra2.part));
  });

  test('Extra', () {
    final extra1 = withExtra1.extra?.toExtra();
    expect(extra1?.toBytes(), equals(withExtra1.extra));

    final extra2 = withExtra2.extra?.toExtra();
    expect(extra2?.toBytes(), equals(withExtra2.extra));
  });

  test('Xzz', () {
    final xzz = noExtra.xzz.toXzz();
    expect(xzz.toBytes(), equals(noExtra.xzz));

    final xzz1 = withExtra1.xzz.toXzz();
    expect(xzz1.toBytes(), equals(withExtra1.xzz));

    final xzz2 = withExtra2.xzz.toXzz();
    expect(xzz2.toBytes(), equals(withExtra2.xzz));
  });
}

final class PcbBytes {
  const PcbBytes({
    required this.pcbSignature,
    required this.offset,
    required this.segments,
    required this.images,
    required this.nets,
    this.extraSignature,
    this.title,
    this.part,
  });

  factory PcbBytes.loadExtra1() {
    final file = File('${Directory.current.path}/test/pcb/extra1.pcb');
    final bytes = file.readAsBytesSync();

    return PcbBytes(
      pcbSignature: bytes.sublist(0, 11),
      offset: bytes.sublist(11, 64),
      segments: bytes.sublist(64, 4720895),
      images: bytes.sublist(4720895, 4720899),
      nets: bytes.sublist(4720899, 4749157),
      extraSignature: bytes.sublist(4749157, 4749169),
      title: bytes.sublist(4749169, 4749180),
      part: bytes.sublist(4749180),
    );
  }

  factory PcbBytes.loadExtra2() {
    final file = File('${Directory.current.path}/test/pcb/extra2.pcb');
    final bytes = file.readAsBytesSync();

    return PcbBytes(
      pcbSignature: bytes.sublist(0, 11),
      offset: bytes.sublist(11, 64),
      segments: bytes.sublist(64, 1608622),
      images: bytes.sublist(1608622, 1609413),
      nets: bytes.sublist(1609413, 1618486),
      extraSignature: bytes.sublist(1618486, 1618497),
      title: bytes.sublist(1618497, 1618505),
      part: bytes.sublist(1618505),
    );
  }

  factory PcbBytes.loadNoExtra() {
    final file = File('${Directory.current.path}/test/pcb/no_extra.pcb');
    final bytes = file.readAsBytesSync();

    return PcbBytes(
      pcbSignature: bytes.sublist(0, 11),
      offset: bytes.sublist(11, 64),
      segments: bytes.sublist(64, 1581396),
      images: bytes.sublist(1581396, 1582187),
      nets: bytes.sublist(1582187, 1591092),
    );
  }

  final List<int> pcbSignature;
  final List<int> offset;
  final List<int> segments;
  final List<int> images;
  final List<int> nets;
  final List<int>? extraSignature;
  final List<int>? title;
  final List<int>? part;

  List<int> get pcb => <int>[
    ...pcbSignature,
    ...offset,
    ...segments,
    ...images,
    ...nets,
  ];

  bool get hasExtra =>
    extraSignature != null &&
    title != null &&
    part != null;

  List<int>? get extra => hasExtra
    ? <int>[
      ...extraSignature!,
      ...title!,
      ...part!,
    ]
    : null;

  List<int> get xzz => <int>[
    ...pcb,
    if (hasExtra)
    ...extra!,
  ];
}
