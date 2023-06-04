import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:todoapp/constants/app_style.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key, required this.titleText, required this.valueText, required this.icon,
  });

  final String titleText;
  final String valueText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            ),
          )
        ],
      ),
    );
  }
}
