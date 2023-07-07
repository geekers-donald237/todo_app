import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoapp/model/todo_model.dart';
import 'package:todoapp/provider/auth_provider.dart';

import '../constants/app_style.dart';
import '../provider/radio_provider.dart';
import '../provider/services_provider.dart';
import '../widget/textfield.dart';

class UpdateTask extends ConsumerWidget {
  const UpdateTask({super.key, required this.todoModel});
  final TodoModel todoModel;

  void openParticipantEmailDialog(BuildContext context, WidgetRef ref) {
    TextEditingController emailController = TextEditingController();
    final data = ref.watch(fireBaseAuthProvider);
    User? user = data.currentUser;
    String currentUserEmail = user!.email.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gestion des participants'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail du participant',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Participants:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: todoModel.participants.length,
                itemBuilder: (context, index) {
                  final participant = todoModel.participants[index];

                  // Vérifier si le participant est différent du currentUser
                  if (participant != currentUserEmail) {
                    return ListTile(
                      title: Text(participant),
                    );
                  } else {
                    // Retourner un widget vide si le participant est le currentUser
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () {
                String participantEmail = emailController.text.trim();
                if (!participantEmail.isEmpty) {
                  if (participantEmail != currentUserEmail) {
                    ref
                        .read(serviceProvider)
                        .addParticipant(todoModel.docID, participantEmail);
                    Fluttertoast.showToast(
                      msg: "Participant ajouté avec succès",
                      backgroundColor: Colors.green.shade300,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      fontSize: 16.0,
                    );
                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(
                      msg: "Vous etes deja un participant",
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      fontSize: 16.0,
                    );
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "Veuillez remplir tous les champs",
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 3,
                    fontSize: 16.0,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController =
        TextEditingController(text: todoModel.titleTask.toString());
    final descriptionController =
        TextEditingController(text: todoModel.descriptionTask.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.3,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    openParticipantEmailDialog(context, ref);
                  },
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                thickness: 1.2,
                color: Colors.grey.shade200,
              ),
              // const SizedBox(height: 0),
              const Text(
                'title',
                style: AppStyle.headingOne,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFieldWidget(
                  maxLine: 1,
                  hintText: todoModel.titleTask.toString(),
                  txtController: titleController,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Description',
                style: AppStyle.headingOne,
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFieldWidget(
                  maxLine: 4,
                  hintText: todoModel.descriptionTask.toString(),
                  txtController: descriptionController,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Nom du  projet associé a la tache: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        todoModel.projectId,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 16, right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade800,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: Colors.blue.shade800,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 10, right: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          final getRadioValue = ref.read(radioProvider);
                          String category = '';

                          switch (getRadioValue) {
                            case 1:
                              category = "Learning";
                              break;
                            case 2:
                              category = "Working";
                              break;
                            case 3:
                              category = "General";
                              break;
                          }

                          if (titleController.text.toString().isEmpty ||
                              descriptionController.text.toString().isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Veuillez remplir tous les champs",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 3,
                                fontSize: 16.0);
                          } else {
                            ref.read(serviceProvider).updateAllTask(
                                todoModel.docID,
                                titleController.text,
                                descriptionController.text,
                                category);

                            Fluttertoast.showToast(
                                msg: "Task update Succefully",
                                backgroundColor: Colors.green.shade300,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 3,
                                fontSize: 16.0);
                          }

                          titleController.clear();
                          descriptionController.clear();
                          ref.read(radioProvider.notifier).update((state) => 1);

                          print('kjhgfdfgvhbjnjkbhgvfdtsrdxfc');
                          print(titleController.text);
                          print(descriptionController.text);
                          Navigator.pop(context);
                        },
                        child: const Text('Update'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
