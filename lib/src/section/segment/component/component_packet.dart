// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../byteable.dart';
import '../../../mappable.dart';
import '../../packet/id_packet.dart';
import 'component.dart';

final class ComponentPacket extends IdPacket implements Mappable {
  const ComponentPacket._({
    required super.id,
    required super.content,
  });

  Component toComponent() => switch (id) {
    UnknownComponent.id => content.toByte().toUnknownComponent(),
    LineComponent.id => content.toByte().toLineComponent(),
    LabelComponent.id => content.toByte().toLabelComponent(),
    PinComponent.id => content.toByte().toPinComponent(),
    _ => throw UnknownComponentException(id),
  };

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'component': toComponent().toMap(),
  };
}

final class UnknownComponentException implements Exception {
  const UnknownComponentException(this.id);

  final int id;

  @override
  String toString() => "Unknown Component '$id'";
}

extension ComponentPacketIterator on Iterator<int> {
  ComponentPacket toComponentPacket() {
    final packet = toIdPacket();

    return ComponentPacket._(
      id: packet.id,
      content: packet.content,
    );
  }
}

extension ComponentPacketMap on Map<String, dynamic> {
  ComponentPacket toComponentPacket() => toComponent().toComponentPacket();

  Component toComponent() {
    final id = this['id'];
    final component = this['component'] as Map<String, dynamic>;

    return switch (id) {
      UnknownComponent.id => component.toUnknownComponent(),
      LineComponent.id => component.toLineComponent(),
      LabelComponent.id => component.toLabelComponent(),
      PinComponent.id => component.toPinComponent(),
      _ => throw UnknownComponentException(id),
    };
  }
}

extension ComponentPacketComponent on Component {
  ComponentPacket toComponentPacket() => ComponentPacket._(
    id: type,
    content: toByte().toByteable(),
  );
}
