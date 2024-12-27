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
    final signatureA = noExtra.pcbSignature.toPcbSignature();
    expect(signatureA.toBytes(), equals(noExtra.pcbSignature));

    final object = signatureA.toJson().toObject();
    final signatureB = object.toJsonMap().toPcbSignature();
    expect(signatureB, equals(signatureA));
  });

  test('Offset', () {
    final offsetA = noExtra.offset.toOffset();
    expect(offsetA.toBytes(), equals(noExtra.offset));

    final object = offsetA.toJson().toObject();
    final offsetB = object.toJsonMap().toOffset();
    expect(offsetB, equals(offsetA));
  });

  test('Segments', () {
    final segmentsA = noExtra.segments.toSegments();
    expect(segmentsA.toBytes(), equals(noExtra.segments));

    final object = segmentsA.toJson().toObject();
    final segmentsB = object.toJsonList().toSegments();
    expect(segmentsB, equals(segmentsA));
  });

  test('Images', () {
    final imagesA = noExtra.images.toImages();
    expect(imagesA.toBytes(), equals(noExtra.images));

    final object = imagesA.toJson().toObject();
    final imagesB = object.toJsonList().toImages();
    expect(imagesB, equals(imagesA));
  });

  test('Nets', () {
    final netsA = noExtra.nets.toNets();
    expect(netsA.toBytes(), equals(noExtra.nets));

    final object = netsA.toJson().toObject();
    final netsB = object.toJsonList().toNets();
    expect(netsB, equals(netsA));
  });

  test('Pcb', () {
    final pcbA = noExtra.pcb.toPcb();
    expect(pcbA.toBytes(), equals(noExtra.pcb));

    final object = pcbA.toJson().toObject();
    final pcbB = object.toJsonMap().toPcb();
    expect(pcbB, equals(pcbA));
  });

  test('ExtraSignature', () {
    final signature1A = withExtra1.extraSignature!.toExtraSignature();
    expect(signature1A.toBytes(), equals(withExtra1.extraSignature));

    final object1 = signature1A.toJson().toObject();
    final signature1B = object1.toJsonList().toExtraSignature();
    expect(signature1B, equals(signature1A));

    final signature2A = withExtra2.extraSignature!.toExtraSignature();
    expect(signature2A.toBytes(), equals(withExtra2.extraSignature));

    final object2 = signature2A.toJson().toObject();
    final signature2B = object2.toJsonList().toExtraSignature();
    expect(signature2B, equals(signature2A));
  });

  test('Title', () {
    final titleA = withExtra1.title!.toTitle();
    expect(titleA.toBytes(), equals(withExtra1.title));

    final object = titleA.toJson().toObject();
    final titleB = object.toJsonList().toTitle();
    expect(titleB, equals(titleA));
  });

  test('Part', () {
    final part1A = withExtra1.part!.toPart1();
    expect(part1A.toBytes(), equals(withExtra1.part));

    final object1 = part1A.toJson().toObject();
    final part1B = object1.toJsonMap().toPart1();
    expect(part1B, equals(part1A));

    final part2A = withExtra2.part!.toPart2();
    expect(part2A.toBytes(), equals(withExtra2.part));

    final object2 = part2A.toJson().toObject();
    final part2B = object2.toJsonMap().toPart2();
    expect(part2B, equals(part2A));
  });

  test('Extra', () {
    final extra1A = withExtra1.extra!.toExtra();
    expect(extra1A.toBytes(), equals(withExtra1.extra));

    final object1 = extra1A.toJson().toObject();
    final extra1B = object1.toJsonMap().toExtra();
    expect(extra1B, equals(extra1A));

    final extra2A = withExtra2.extra!.toExtra();
    expect(extra2A.toBytes(), equals(withExtra2.extra));

    final object2 = extra2A.toJson().toObject();
    final extra2B = object2.toJsonMap().toExtra();
    expect(extra2B, equals(extra2A));
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

  final Bytes pcbSignature;
  final Bytes offset;
  final Bytes segments;
  final Bytes images;
  final Bytes nets;
  final Bytes? extraSignature;
  final Bytes? title;
  final Bytes? part;

  Bytes get pcb => [
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

  Bytes? get extra => hasExtra
    ? [
      ...extraSignature!,
      ...title!,
      ...part!,
    ]
    : null;

  Bytes get xzz => [
    ...pcb,
    if (hasExtra)
    ...extra!,
  ];
}
