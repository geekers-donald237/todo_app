import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'authDetails/profil.dart';
import 'home.dart';

class CategorieList extends StatefulWidget {
  const CategorieList({super.key});

  @override
  State<CategorieList> createState() => _CategorieListState();
}

class _CategorieListState extends State<CategorieList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text("Pas encore prete"),
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ));
              },
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.category),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategorieList(),
                ));
              },
            ),
            label: 'categori',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile(),
                ));
              },
            ),
            label: 'Profil',
          ),

        ],
        currentIndex: 1,
        selectedItemColor: Colors.blue.shade300,
        onTap: (index) {},
      ),
   
    );
  }
}