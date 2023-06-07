// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  int calculateHourDifference(String dateString) {
    final DateFormat format = DateFormat('dd/MM/yy');

    // Conversion de la chaîne de caractères en objet DateTime
    final DateTime date = format.parse(dateString);

    // Récupération de la date et de l'heure actuelles
    final DateTime now = DateTime.now();

    // Calcul de la différence en heures
    final int differenceInHours = now.difference(date).inDays;

    return differenceInHours;
  }

  Color getColorByHourDifference(int hourDifference) {
    if (hourDifference <= 2) {
      // Moins de 24 heures de différence
      return Colors.red;
    } else if (hourDifference <= 15) {
      // Entre 24 et 48 heures de différence
      return Colors.orange;
    } else if (hourDifference <= 40) {
      // Entre 48 et 72 heures de différence
      return Colors.yellow;
    } else {
      // Plus de 72 heures de différence
      return Colors.green;
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
        int difference = calculateHourDifference(date);
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateTask(
                              todoModel: todoData[getIndex],
                            ),
                          ));
                        },
                        contentPadding: EdgeInsets.zero,
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
                                                getColorByHourDifference(
                                                    -1 * (difference))),
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
