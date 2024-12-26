// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/jsonable.dart';
import 'resistance.dart';
import 'text_type.dart';

final class ResistanceType extends TextType implements Jsonable {
  const ResistanceType(super.content);

  @override
  Json toJson() => toResistance().toJson();
}

extension ResistanceTypeOnJson on Json {
  ResistanceType toResistanceType() => toResistance().toResistanceType();
}

extension ResistanceTypeOnMap on Map<String, Object?> {
  ResistanceType toResistanceType() => toJson().toResistanceType();
}

extension ResistanceTypeOnResistance on Resistance {
  ResistanceType toResistanceType() => ResistanceType(toText());
}

extension ResistanceTypeOnTextType on TextType {
  ResistanceType toResistanceType() => ResistanceType(content);
}
