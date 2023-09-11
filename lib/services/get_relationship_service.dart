import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeless_love_app/providers/relationship_provider.dart';
import '../models/relationship.dart';

Relationship? readRelationship(BuildContext context) {
  return context.read<RelationshipProvider>().relationship;
}

Relationship? watchRelationship(BuildContext context) {
  return context.watch<RelationshipProvider>().relationship;
}
