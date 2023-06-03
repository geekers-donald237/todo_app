import 'dart:html';
import 'package:flutter/material.dart';

class modifTask extends StatefulWidget {
  const modifTask({Key? key}) : super(key: key);

  @override
  State<modifTask> createState() => _modifTaskState();
}

class _modifTaskState extends State<modifTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("MODIFIER LA TACHE",),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          onPressed: (){},
        )
      ),

      body: Container(
        padding: EdgeInsets.all(15.0),

      ),
    );
  }
}


