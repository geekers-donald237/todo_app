import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/constants/app_style.dart';
import 'package:todoapp/provider/date_time_provider.dart';
import 'package:todoapp/provider/radio_provider.dart';
import 'package:todoapp/widget/dateTime.dart';
import 'package:todoapp/widget/radio.dart';
import 'package:todoapp/widget/textfield.dart';

import '../model/todo_model.dart';
import '../provider/auth_provider.dart';
import '../provider/services_provider.dart';

class AddNewTaskModel extends ConsumerWidget {
  AddNewTaskModel({
    super.key,
  });

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateProv = ref.watch(dateProvider);
    final data = ref.watch(fireBaseAuthProvider);
    final auth = ref.watch(authenticationProvider);
    User? user = data.currentUser;
    String currentUserEmail = user!.email.toString();
    return Container(
      padding: const EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                'New Task Todo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(
              thickness: 1.2,
              color: Colors.grey.shade200,
            ),
            const Gap(12),
            const Text(
              'Title Task ',
              style: AppStyle.headingOne,
            ),
            TextFieldWidget(
              maxLine: 1,
              hintText: 'Add Task name.',
              txtController: titleController,
            ),
            const Gap(12),
            const Text(
              'Description',
              style: AppStyle.headingOne,
            ),
            const Gap(6),
            TextFieldWidget(
              maxLine: 4,
              hintText: 'Add descriptions',
              txtController: descriptionController,
            ),
            const Gap(12),
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

            //Date and Time Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DateTimeWidget(
                  icon: CupertinoIcons.calendar,
                  valueText: dateProv,
                  titleText: 'Date',
                  onTap: () async {
                    final getValue = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2025));

                    if (getValue != null) {
                      final format = DateFormat.yMd();
                      ref
                          .read(dateProvider.notifier)
                          .update((state) => format.format(getValue));
                    }
                  },
                ),
                const Gap(22),
                DateTimeWidget(
                  titleText: 'Time',
                  valueText: ref.watch(timeProvider),
                  icon: CupertinoIcons.clock,
                  onTap: () async {
                    final getTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (getTime != null) {
                      ref
                          .read(timeProvider.notifier)
                          .update((state) => getTime.format(context));
                    }
                  },
                ),
              ],
            ),
            const Gap(12),
            //Button section
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                const SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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


                        ref.read(serviceProvider).addNewTask(TodoModel(
                              titleTask: 'General manner',
                              descriptionTask: 'one another task',
                              category: category,
                              dateTask: ref.read(dateProvider),
                              timeTask: ref.read(timeProvider),
                              isDone: false,
                              participants: [currentUserEmail],
                            ));

                        titleController.clear();
                        descriptionController.clear();
                        ref.read(radioProvider.notifier).update((state) => 0);
                        print(titleController.text +
                            " lkjhjkjhjjj " +
                            descriptionController.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Create'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
