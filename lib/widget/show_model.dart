import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoapp/constants/app_style.dart';
import 'package:todoapp/widget/dateTime.dart';
import 'package:todoapp/widget/radio.dart';
import 'package:todoapp/widget/textfield.dart';

class AddNewTaskModel extends StatelessWidget {
  const AddNewTaskModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
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
            TextFieldWidget(maxLine: 1, hintText: 'Add Task name.'),
            const Gap(12),
            const Text(
              'Description',
              style: AppStyle.headingOne,
            ),
            Gap(6),
            TextFieldWidget(maxLine: 4, hintText: 'Add descriptions'),
            Gap(12),
            Text(
              'Category',
              style: AppStyle.headingOne,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioWidget(
                    titleRadio: "LRN",
                    categColor: Colors.green,
                  ),
                ),
                Expanded(
                  child: RadioWidget(
                    titleRadio: "WRK",
                    categColor: Colors.blue.shade700,
                  ),
                ),
                Expanded(
                  child: RadioWidget(
                    titleRadio: "GEN",
                    categColor: Colors.amberAccent.shade700,
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
                  valueText: 'dd/mm/yy',
                  titleText: 'Date',
                ),
                Gap(22),
                DateTimeWidget(
                  titleText: 'Time',
                  valueText: 'hh : mm',
                  icon: CupertinoIcons.clock,
                ),
              ],
            ),
            Gap(12),
            //Button section
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
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
                      onPressed: () {},
                      child: Text('Cancel'),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
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
                      onPressed: () {},
                      child: Text('Create'),
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
