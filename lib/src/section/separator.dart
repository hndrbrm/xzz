// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../bytes_helper/iterator_helper.dart';
import '../bytes_helper/list_helper.dart';
import '../bytes_helper/string_helper.dart';
import '../serializable/jsonable.dart';
import '../serializable/serializable.dart';

final class Separator implements Serializable {
  const Separator._(this.id);

  final String id;

  @override
  List<int> toBytes() => id.toString8List();

  @override
  JsonList toJson() => id.toJsonList();

  @override
  bool operator ==(Object other) =>
    other is Separator &&
    other.id == id;

  @override
  int get hashCode => id.hashCode;
}

final class InvalidSeparatorException extends FormatException {}

extension SeparatorIterator on Iterator<int> {
  static const _id = 'v6v6555v6v6===';

  Separator toSeparator() {
    final id = read(_id.length).toString8();

    if (id != _id) {
      throw InvalidSeparatorException();
    }

    return Separator._(id);
  }
}

extension SeparatorJsonMap on JsonList {
  Separator toSeparator() => toObject().toSeparator();
}

extension SeparatorList on List<int> {
  int findSeparator() => _findMarker(
    this,
    SeparatorIterator._id.toString8List(),
  );

  int _findMarker(List<int> content, List<int> marker) {
    for (var i = 0; i <= content.length - marker.length; i++) {
      var found = true;

      for (var j = 0; j < marker.length; j++) {
        if (content[i + j] != marker[j]) {
          found = false;
          break;
        }
      }

      if (found) {
        return i;
      }
    }

    return -1;
  }
}

extension SeparatorMap on List<Object?> {
  Separator toSeparator() => Separator._(toBytes().toString8());
}
