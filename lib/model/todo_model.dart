import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? docID;
  final String titleTask;
  final String descriptionTask;
  final String category;
  final String dateTask;
  final String timeTask;
  final bool isDone;
  List<String> participants; // Champ pour stocker les participants

  TodoModel({
    this.docID,
    required this.titleTask,
    required this.descriptionTask,
    required this.category,
    required this.dateTask,
    required this.timeTask,
    required this.isDone,
    required this.participants, // Ajout du champ des participants
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'titleTask': titleTask,
      'descriptionTask': descriptionTask,
      'category': category,
      'dateTask': dateTask,
      'timeTask': timeTask,
      'isDone': isDone,
      'participants': participants, // Ajout du champ des participants
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      docID: map['docID'] != null ? map['docID'] as String : null,
      titleTask: map['titleTask'] as String,
      descriptionTask: map['descriptionTask'] as String,
      category: map['category'] as String,
      dateTask: map['dateTask'] as String,
      timeTask: map['timeTask'] as String,
      isDone: map['isDone'] as bool,
      participants: List<String>.from(map['participants']), // Ajout du champ des participants
    );
  }

  factory TodoModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return TodoModel(
      docID: doc.id,
      titleTask: doc['titleTask'],
      descriptionTask: doc['descriptionTask'],
      category: doc['category'],
      dateTask: doc['dateTask'],
      timeTask: doc['timeTask'],
      isDone: doc['isDone'],
      participants: List<String>.from(doc['participants']), // Ajout du champ des participants
    );
  }
}
