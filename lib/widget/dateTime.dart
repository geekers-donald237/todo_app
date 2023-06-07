import 'package:flutter/cupertino.dart';
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:todoapp/constants/app_style.dart';

class DateTimeWidget extends ConsumerWidget {
  const DateTimeWidget({
    super.key,
    required this.titleText,
    required this.valueText,
    required this.icon, required this.onTap,
=======
import 'package:gap/gap.dart';
import 'package:todoapp/constants/app_style.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key, required this.titleText, required this.valueText, required this.icon,
>>>>>>> 6e5253a (setup newest view for addtodo)
  });

  final String titleText;
  final String valueText;
  final IconData icon;
<<<<<<< HEAD
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context , WidgetRef ref) {
=======

  @override
  Widget build(BuildContext context) {
>>>>>>> 6e5253a (setup newest view for addtodo)
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          Text(
            titleText,
            style: AppStyle.headingOne,
          ),
          Material(
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onTap(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(icon),
                      Gap(12),
                      Text(valueText),
                    ],
                  ),
                ),
              ),
=======
           Text(
            titleText,
            style: AppStyle.headingOne,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon),
                Gap(12),
                Text(valueText),
              ],
>>>>>>> 6e5253a (setup newest view for addtodo)
            ),
          )
        ],
      ),
    );
  }
}
