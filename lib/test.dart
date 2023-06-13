import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCat extends StatefulWidget {

  @override
  State<AddCat> createState() => _AddCatState();
}

class _AddCatState extends State<AddCat> {

  List<String> notes = [];
  String name;

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  void getNotes() async {
    notes.clear();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('categorie')
          .doc("c")
          .get();
     final n= querySnapshot.data()['cat'];
     for (var i = 0; i < n.length; i++) {
       notes.add(n[i]);
     }
     notes.sort();
     setState(
          () {});// rafraîchir l'affichage pour afficher les nouvelles notes
    } catch (e) {
      notes.add("vide");
    }
  }

  void del(int i){
    notes.removeAt(i);
    FirebaseFirestore.instance
                  .collection('categorie')
                  .doc('c')
                  .set({'cat':notes});
  }

  void add(String val){
    if (!rech(val)) {
    notes.add(val);
    FirebaseFirestore.instance
                  .collection('categorie')
                  .doc('c')
                  .set({'cat':notes});
    }
  }

  bool rech(String val){
    for (var i = 0; i < notes.length; i++) {
      if(notes[i]==val){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                title: Text(notes[index], style: TextStyle(fontSize: 20)),
                leading: CircleAvatar(
                  child: Text(
                      notes[index][0],
                      style: TextStyle(fontSize: 20)),
                ),trailing: 
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: (){del(index);getNotes();}, 
          ),),);
        },
        itemCount: notes.length,
      ),floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add), //child widget inside this button
      onPressed: (){
        return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New categorie'),
          content: TextFormField(
                                onChanged: (value) =>
                                    setState(() => name = value),
                                decoration: InputDecoration(
                                  hintText: 'Ex: Cours',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                maxLength: 100,
                              ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                if (!name.isEmpty) {
                add(name);
                getNotes();
                }
                name="";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    },
  ),
    );
  }
}