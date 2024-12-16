// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../bytes_helper/string_helper.dart';

class Jsonable {
  Jsonable._(this._toJson);

  final Json Function() _toJson;

  Json toJson() => _toJson();
}

sealed class Json {
  Object? toObject();
}

final class JsonMap implements Json {
  const JsonMap._(this.value);

  final Map<String, Json> value;

  @override
  Map<String, Object?> toObject() =>
    value.map((k, v) => MapEntry(k, v.toObject()));
}

final class JsonList implements Json {
  const JsonList._(this.value);

  final Iterable<Json> value;

  @override
  List<Object?> toObject() =>
    value.map((e) => e.toObject()).toList();
}

final class JsonNum implements Json {
  const JsonNum._(this.value);

  final num value;

  @override
  num toObject() => value;
}

final class JsonString implements Json {
  const JsonString._(this.value);

  final String value;

  @override
  String toObject() => value;
}

final class JsonNull implements Json {
  const JsonNull._();

  @override
  Null toObject() => null;
}

final class InvalidJsonException implements Exception {
  const InvalidJsonException(this.id);

  final Type id;

  @override
  String toString() => "Invalid Json '$id'";
}

extension JsonableMap on Json {
  Jsonable toJsonable() => Jsonable._(() => this);
}

extension JsonListList on Iterable<Object?> {
  JsonList toJsonList() => JsonList._(
    map((e) => e.toJson()),
  );
}

extension JsonListString on String {
  JsonList toJsonList() => toString8List().toJsonList();
}

extension JsonMapMap on Map<String, Object?> {
  JsonMap toJsonMap() => JsonMap._(
    map(
      (k, v) => MapEntry(k, v.toJson()),
    ),
  );
}

extension JsonObject on Object? {
  Json toJson() => switch (this) {
    null => const JsonNull._(),
    final Json value => value,
    final Map<String, Object?> value => value.toJsonMap(),
    final List<Object?> value => value.toJsonList(),
    final num value => JsonNum._(value),
    final String value => JsonString._(value),
    _ => throw InvalidJsonException(runtimeType),
  };
}

extension ListExtension on List<Object?> {
  List<int> toBytes() => map((e) => e! as int).toList();
}
