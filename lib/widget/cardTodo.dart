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

    return differenceInDays.abs();
  }

  int calculateTaskDuration(String startDateString, String endDateString) {
    final DateFormat format = DateFormat('MM/dd/yyyy');

    // Conversion des chaînes de caractères en objets DateTime
    final DateTime startDate = format.parse(startDateString);
    final DateTime endDate = format.parse(endDateString);

    // Calcul de la différence en jours
    final int durationInDays = endDate.difference(startDate).inDays;

    return durationInDays.abs();
  }

  int calculateProgressPercentage(int taskDuration, int remainingDuration) {
    // Vérification pour éviter une division par zéro
    if (taskDuration <= 0) {
      return 0;
    }

    // Calcul du pourcentage de progression
    double progressPercentage =
        ((taskDuration - remainingDuration) / taskDuration) * 100;

    // Limite le pourcentage entre 0 et 100
    progressPercentage = progressPercentage.clamp(0.0, 100.0);

    // Arrondi à l'entier le plus proche
    final roundedPercentage = progressPercentage.round();

    return roundedPercentage;
  }

  Color getColorByProgress(int progress) {
    if (progress >= 0 && progress <= 24) {
      // Moins de 2% de progression
      return Colors.green; // Rouge
    } else if (progress <= 25) {
      // Entre 2% et 15% de progression
      return Colors.yellow; // Rouge orangé
    } else if (progress <= 60) {
      // Entre 15% et 40% de progression
      return Color.fromARGB(207, 252, 80, 80); // Jaune
    } else {
      // Plus de 40% de progression
      return const Color.fromARGB(255, 235, 21, 6); // Vert
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color categoryColor = Colors.white;
    final todoData = ref.watch(fetchStreamProvider);
    String date = '';
    String dateStart = '';
    int valueIndicator;
    Color indicatorColor;

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
        dateStart = todoData[getIndex].dateTaskStart.toString();
        int difference = calculateDayDifference(date);
        print('Différence en jours entre ajourdhui et la fin : $difference');
        int taskDuration = calculateTaskDuration(dateStart, date);
        print('taskk Duration $taskDuration');
        valueIndicator = calculateProgressPercentage(taskDuration, difference);
        print(valueIndicator);
        indicatorColor = getColorByProgress(valueIndicator);

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
                                        value: valueIndicator / 100,
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                indicatorColor),
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
