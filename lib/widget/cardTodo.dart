import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/provider/services_provider.dart';
import 'package:todoapp/view/updateTask.dart';

class cardTodoListWidget extends ConsumerWidget {
  const cardTodoListWidget({
    super.key,
    required this.getIndex,
  });

  final int getIndex;
  int calculateDayDifference(String dateString) {
    final DateFormat format = DateFormat('MM/dd/yyyy');

    // Conversion de la chaîne de caractères en objet DateTime
    final DateTime date = format.parse(dateString);

    // Récupération de la date actuelle
    final DateTime now = DateTime.now();

    // Calcul de la différence en jours
    final int differenceInDays = now.difference(date).inDays;

    return -1 * differenceInDays;
  }

  Color getColorByDayDifference(int dayDifference) {
    if (dayDifference >= 0 && dayDifference <= 2) {
      // Moins de 2 jours de différence
      return const Color.fromARGB(255, 235, 21, 6); // Rouge
    } else if (dayDifference <= 15) {
      // Entre 2 et 15 jours de différence
      return Color.fromARGB(207, 252, 80, 80); // Rouge orangé
    } else if (dayDifference <= 40) {
      // Entre 15 et 40 jours de différence
      return Colors.yellow; // Jaune
    } else {
      // Plus de 40 jours de différence
      return Colors.green; // Vert
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color categoryColor = Colors.white;
    final todoData = ref.watch(fetchStreamProvider);
    String date = '';

    return todoData.when(
      data: (todoData) {
        final getCategory = todoData[getIndex].category;

        switch (getCategory) {
          case 'Learning':
            categoryColor = Colors.green;
            break;

          case 'Working':
            categoryColor = Colors.blue.shade700;
            break;

          case 'General':
            categoryColor = Colors.amber.shade700;
            break;
          default:
        }

        date = todoData[getIndex].dateTask.toString();
        int difference = calculateDayDifference(date);
        print('Différence en heures : $difference');

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Container(
              decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  )),
              width: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {
                          print(todoData[getIndex].participants);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateTask(
                              todoModel: todoData[getIndex],
                            ),
                          ));
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: IconButton(
                            icon: Icon(CupertinoIcons.delete),
                            onPressed: () {
                              ref
                                  .read(serviceProvider)
                                  .deleteTask(todoData[getIndex].docID);
                              Fluttertoast.showToast(
                                  msg: "Task delete Succefully",
                                  backgroundColor: Colors.orange.shade300,
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 3,
                                  fontSize: 16.0);
                            }),
                        title: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4), // Ajouter un espace vertical
                          child: Text(
                            todoData[getIndex].titleTask,
                            maxLines: 2,
                            style: TextStyle(
                              decoration: todoData[getIndex].isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8), // Ajouter un espace vertical
                          child: Text(
                            todoData[getIndex].descriptionTask,
                            maxLines: 3,
                            style: TextStyle(
                              decoration: todoData[getIndex].isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        trailing: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.blue.shade800,
                            shape: CircleBorder(),
                            value: todoData[getIndex].isDone,
                            onChanged: (value) => ref
                                .read(serviceProvider)
                                .updateTask(todoData[getIndex].docID, value),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -12),
                        child: Container(
                          child: Column(
                            children: [
                              Divider(
                                thickness: 1.5,
                                color: Colors.grey.shade200,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Text(todoData[getIndex].dateTask),
                                  ),
                                  Gap(12),
                                  Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Text(todoData[getIndex].timeTask),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 8), // Espace entre les deux lignes
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: LinearProgressIndicator(
                                        value: 8,
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                getColorByDayDifference(
                                                    (difference))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(stackTrace.toString()),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
