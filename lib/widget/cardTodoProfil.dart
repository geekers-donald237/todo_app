import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/services_provider.dart';

class CardTodoProfile extends ConsumerWidget {
  const CardTodoProfile({
    Key? key,
    required this.getIndex,
  }) : super(key: key);

  final int getIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(fetchStreamProvider);

    return todoData.when(
      data: (todoData) {
        final todo = todoData[getIndex];

        return Card(
          elevation: 4,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            print(todoData[getIndex].participants);
                          },
                          contentPadding: EdgeInsets.zero,
                          title: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
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
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 6),
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Text(todoData[getIndex].dateTask),
                              ),
                            ],
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
                                SizedBox(
                                    height: 2), // Espace entre les deux lignes
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
