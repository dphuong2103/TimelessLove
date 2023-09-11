import 'package:flutter/material.dart';
import '../models/relationship.dart';

class RelationshipProvider with ChangeNotifier {
  Relationship? _relationship;
  Relationship? get relationship => _relationship;

  set relationship(Relationship? relationship) {
    _relationship = relationship;
    notifyListeners();
  }

  set relationshipWithoutNotify(Relationship? relationship) {
    _relationship = relationship;
  }
}
