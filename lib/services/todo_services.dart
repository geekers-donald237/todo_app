import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/model/todo_model.dart';

class TodoService {
  final todoCollection = FirebaseFirestore.instance.collection('todoApp');

  // CREATE TODO

  void addNewTask(TodoModel model) {
    todoCollection.add(model.toMap());
  }

  //UPDATE
  void updateTask(String? docID, bool? valueUpdate) {
    todoCollection.doc(docID).update({
      'isDone': valueUpdate,
    });
  }

  //Delete
  void deleteTask(String? docID) {
    todoCollection.doc(docID).delete();
  }

  void updateAllTask(
      String? docID, String newTitle, String newDescription, String newCategorie) {
    todoCollection.doc(docID).update({
      'titleTask': newTitle,
      'descriptionTask': newDescription,
      'category': newCategorie
    });
  }

  void addParticipant(String? docID, String participantEmail) {
    todoCollection.doc(docID).update({
      'participants': FieldValue.arrayUnion([participantEmail]),
    });
  }


}
