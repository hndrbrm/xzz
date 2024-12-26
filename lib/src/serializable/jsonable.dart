// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../bytes_helper/string_helper.dart';

class Jsonable with JsonableMixin {
  const Jsonable._([ this._toJson ]);

  @override
  final Json Function()? _toJson;
}

mixin JsonableMixin {
  Json Function()? get _toJson;

  Json toJson() =>
    _toJson?.call() ??
    (throw UnimplementedError('$runtimeType'));
}

sealed class Json {
  Object? toObject();
}

final class JsonMap implements Json {
  const JsonMap._(this._value);

  final Map<String, Json> _value;

  @override
  Map<String, Object?> toObject() =>
    _value.map((k, v) => MapEntry(k, v.toObject()));
}

final class JsonList implements Json {
  const JsonList._(this._value);

  final Iterable<Json> _value;

  @override
  List<Object?> toObject() =>
    _value.map((e) => e.toObject()).toList();
}

final class JsonNum implements Json {
  const JsonNum._(this._value);

  final num _value;

  @override
  num toObject() => _value;
}

final class JsonString implements Json {
  const JsonString._(this._value);

  final String _value;

  @override
  String toObject() => _value;
}

final class JsonNull implements Json {
  const JsonNull._();

  @override
  Null toObject() => null;
}

final class InvalidJsonException implements Exception {
  const InvalidJsonException(this._id);

  final Type _id;

  @override
  String toString() => "Invalid Json '$_id'";
}

extension JsonableMap on Json {
  Jsonable toJsonable() => Jsonable._(() => this);
}

extension JsonBytes on Json {
  List<int> toBytes() => jsonEncode(toObject()).toString8List();
}

extension JsonListIterable on Iterable<Object?> {
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
