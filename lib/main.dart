import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoapp/widget/show_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
   }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title:  ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber.shade200,
            radius: 35,
            child: Image.asset('assets/avatar.png'),
          ),
          title: Text("Hello I'm ",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,),),
          subtitle: Text("Idris dd",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),) ,
        ),
        centerTitle: true,
        actions: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.calendar)),
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bell)),
          ],),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Today's Taks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black ),),
                      Text("Sunday , 4 june", style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD5E8FA),
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                      onPressed: () => showModalBottomSheet(
                          isScrollControlled: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          context: context,
                          builder: (context) => AddNewTaskModel()),
                      child: Text("+ New Task",style: TextStyle(color: Colors.black),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


