import 'dart:html';
import 'package:flutter/material.dart';


class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context, String nom, String prenom, List todo ) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Mon profil",),
    leading: IconButton(
    icon: Icon(
    Icons.arrow_back,
    color: Colors.pinkAccent,
    ),
    onPressed: () {},
    ),
    ),
    body: Container(
      padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 20),
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color : Colors.black.withOpacity(0.1)
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover, image: null,
                        )
                    ),
                  ),
                  SizedBox(width: 30),
                  Text("onalaeti_123" , style: TextStyle(
                      fontSize: 13,
                      color: Colors.black38
                  )),
                  SizedBox(width: 30)
                ],
              ),
            ),
            SizedBox(height: 30),
            buildTextField("mon nom",nom ),
            buildTextField("prenom", prenom),
            buildTextField("tache en cours", ),
            ListView(
              scrollDirection: Axis.vertical,
              children: [],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(onPressed: (){},
                  child: const Text("Cancel",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black,
                      )),
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                ),
                ElevatedButton(
                  child: Text("save", style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 2,
                    color: Colors.white,
                  )),
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding:EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
    );

  }

  Widget buildTextField( String label, String placeholder){
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
            )
        ),
      ),
    );
  }
}
