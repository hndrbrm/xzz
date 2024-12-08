// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../packet/id_packet.dart';
import 'component.dart';

final class ComponentPacket extends IdPacket {
  const ComponentPacket({
    required super.id,
    required super.content,
  });

  ComponentPacket.deserialize(super.iterator)
  : super.deserialize();

  Component get silk => switch (id) {
    UnknownComponent.id => UnknownComponent.deserialize(content),
    LineComponent.id => LineComponent.deserialize(content),
    LabelComponent.id => LabelComponent.deserialize(content),
    PinComponent.id => PinComponent.deserialize(content.iterator),
    _ => throw UnknownComponentException(id),
  };
}

final class UnknownComponentException implements Exception {
  const UnknownComponentException(this.id);

  final int id;

  @override
  String toString() => "Unknown Component '$id'";
}
