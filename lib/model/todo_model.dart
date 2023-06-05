// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? docID;
  final String titleTask;
  final String descriptionTask;
  final String categoryTask;
  final String dateTask;
  final String timeTask;
  TodoModel({
    this.docID,
    required this.titleTask,
    required this.descriptionTask,
    required this.categoryTask,
    required this.dateTask,
    required this.timeTask,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docID': docID,
      'titleTask': titleTask,
      'descriptionTask': descriptionTask,
      'categoryTask': categoryTask,
      'dateTask': dateTask,
      'timeTask': timeTask,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      docID: map['docID'] != null ? map['docID'] as String : null,
      titleTask: map['titleTask'] as String,
      descriptionTask: map['descriptionTask'] as String,
      categoryTask: map['categoryTask'] as String,
      dateTask: map['dateTask'] as String,
      timeTask: map['timeTask'] as String,
    );
  }

  factory TodoModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return TodoModel(
      docID : doc.id,
        titleTask: doc['titleTask'],
        descriptionTask: doc['descriptionTask'],
        categoryTask: doc['category'],
        dateTask: doc['dateTask'],
        timeTask: doc['timeTask']);
  }
}
