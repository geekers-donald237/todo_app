import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/provider/radio_provider.dart';

class RadioWidget extends ConsumerWidget {
  const RadioWidget({
    super.key,
    required this.titleRadio,
    required this.categColor,
    required this.valueInput,
    required this.onChangedValue,
=======

class RadioWidget extends StatelessWidget {
  const RadioWidget({
    super.key, required this.titleRadio, required this.categColor,
>>>>>>> 6e5253a (setup newest view for addtodo)
  });

  final String titleRadio;
  final Color categColor;
<<<<<<< HEAD
  final int valueInput;
  final VoidCallback onChangedValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radio = ref.watch(radioProvider);
    return Theme(
      data: ThemeData(unselectedWidgetColor: categColor),
      child: Material(
        child: RadioListTile(
            activeColor: categColor,
            contentPadding: EdgeInsets.zero,
            title: Transform.translate(
                offset: Offset(-22, 0),
                child: Text(
                  titleRadio,
                  style: TextStyle(
                    color: categColor,
                    fontWeight: FontWeight.w700,
                  ),
                )),
            value: valueInput,
            groupValue: radio,
            onChanged: (value) => onChangedValue(), ),
=======

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor:categColor),
      child: Material(
        child: RadioListTile(
            contentPadding: EdgeInsets.zero,
            title: Transform.translate(
                offset: Offset(-22, 0), child: Text(titleRadio,style: TextStyle(
                  color: categColor,
                  fontWeight: FontWeight.w700,

                ),)),
            value: 1,
            groupValue: 0,
            onChanged: (value) {
              print('clicked');
            }),
>>>>>>> 6e5253a (setup newest view for addtodo)
      ),
    );
  }
}
