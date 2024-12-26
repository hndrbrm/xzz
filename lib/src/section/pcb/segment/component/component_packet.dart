// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../../bytes_helper/list_helper.dart';
import '../../../../serializable/bytesable.dart';
import '../../../../serializable/jsonable.dart';
import '../../../packet/id_packet.dart';
import 'component.dart';

final class ComponentPacket extends IdPacket implements Jsonable {
  const ComponentPacket._({
    required super.id,
    required super.content,
  });

  Component toComponent() => switch (id) {
    UnknownComponent.id => content.toBytes().toUnknownComponent(),
    LineComponent.id => content.toBytes().toLineComponent(),
    LabelComponent.id => content.toBytes().toLabelComponent(),
    PinComponent.id => content.toBytes().toPinComponent(),
    _ => throw UnknownComponentException(id),
  };

  @override
  JsonMap toJson() => {
    'id': id,
    'component': toComponent().toJson(),
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is ComponentPacket &&
    other.id == id &&
    listEqual(other.content.toBytes(), content.toBytes());

  @override
  int get hashCode => Object.hash(
    id,
    Object.hashAll(content.toBytes()),
  );
}

final class UnknownComponentException implements Exception {
  const UnknownComponentException(this._id);

  final int _id;

  @override
  String toString() => "Unknown Component '$_id'";
}

extension ComponentPacketOnComponent on Component {
  ComponentPacket toComponentPacket() => ComponentPacket._(
    id: type,
    content: toBytes().toBytesable(),
  );
}

extension ComponentPacketOnIterator on Iterator<int> {
  ComponentPacket toComponentPacket() {
    final packet = toIdPacket();

    return ComponentPacket._(
      id: packet.id,
      content: packet.content,
    );
  }
}

extension ComponentPacketOnJsonMap on JsonMap {
  ComponentPacket toComponentPacket() => toObject().toComponentPacket();
}

extension ComponentPacketOnMap on Map<String, Object?> {
  ComponentPacket toComponentPacket() => toComponent().toComponentPacket();

  Component toComponent() {
    final id = this['id']! as int;
    final component = this['component']! as Map<String, Object?>;

    return switch (id) {
      UnknownComponent.id => component.toUnknownComponent(),
      LineComponent.id => component.toLineComponent(),
      LabelComponent.id => component.toLabelComponent(),
      PinComponent.id => component.toPinComponent(),
      _ => throw UnknownComponentException(id),
    };
  }
}
