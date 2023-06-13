import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:todoapp/model/todo_model.dart';
import 'package:todoapp/provider/auth_provider.dart';
import 'package:todoapp/view/home.dart';

import '../constants/app_style.dart';
import '../provider/radio_provider.dart';
import '../provider/services_provider.dart';
import '../widget/radio.dart';
import '../widget/textfield.dart';

class UpdateTask extends ConsumerWidget {
  const UpdateTask({super.key, required this.todoModel});
  final TodoModel todoModel;

  void openParticipantEmailDialog(BuildContext context, WidgetRef ref) {
    TextEditingController emailController = TextEditingController();
    final data = ref.watch(fireBaseAuthProvider);
    final auth = ref.watch(authenticationProvider);
    User? user = data.currentUser;
    String currentUserEmail = user!.email.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gestion des participants'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail du participant',
                ),
              ),
              SizedBox(height: 16),
              Text('Participants:'),
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
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () {
                String participantEmail = emailController.text;
                print('E-mail du participant : $participantEmail');
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
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(fetchStreamProvider);
    final titleController = TextEditingController(text:todoModel.titleTask.toString());
    final descriptionController = TextEditingController(text: todoModel.descriptionTask.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.3,
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    openParticipantEmailDialog(context, ref);
                  },
                  icon: Icon(Icons.person_add_alt_1_outlined),
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
              const Text(
                'Category',
                style: AppStyle.headingOne,
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioWidget(
                      titleRadio: "LRN",
                      categColor: Colors.green,
                      valueInput: 1,
                      onChangedValue: () =>
                          ref.read(radioProvider.notifier).update((state) => 1),
                    ),
                  ),
                  Expanded(
                    child: RadioWidget(
                      titleRadio: "WRK",
                      categColor: Colors.blue.shade700,
                      valueInput: 2,
                      onChangedValue: () =>
                          ref.read(radioProvider.notifier).update((state) => 2),
                    ),
                  ),
                  Expanded(
                    child: RadioWidget(
                      titleRadio: "GEN",
                      categColor: Colors.amberAccent.shade700,
                      valueInput: 3,
                      onChangedValue: () =>
                          ref.read(radioProvider.notifier).update((state) => 3),
                    ),
                  ),
                ],
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
