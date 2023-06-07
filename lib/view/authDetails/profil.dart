import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/provider/services_provider.dart';
import 'package:todoapp/view/category.dart';
import 'package:todoapp/view/home.dart';

import '../../provider/auth_provider.dart';
import '../../widget/cardTodo.dart';

class Profile extends ConsumerWidget {
  bool showControls = false;
  String? photoURl;
  String email = '';
  File? imageFile;
  bool isEditing = false;
  bool _loading = false;

  String extractNameFromEmail(String email) {
    if (email.isEmpty) {
      return '';
    }
    int index = email.indexOf('@');
    if (index == -1) {
      return email;
    }
    return email.substring(0, index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(fireBaseAuthProvider);
    final auth = ref.watch(authenticationProvider);
    User? user = data.currentUser;
    String photoUrl = '', nom = '';
    String providerId = user?.providerData[0].providerId ?? '';
    print(providerId);
    final todoData = ref.watch(fetchStreamProvider); // erreur ici
    if (providerId == 'google.com') {
      photoUrl = user!.photoURL.toString();
      nom = user.displayName.toString();
    } else {
      photoUrl =
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fgithub.com%2FJerry8538&psig=AOvVaw0DkyHx1yLcIZ0rY-zUmnla&ust=1686227516406000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCLDou6eHsf8CFQAAAAAdAAAAABAE";
      nom = extractNameFromEmail(user!.email.toString());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon profil"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade300),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.blue.shade300,
            onPressed: () async {
              auth.signOut();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.blue,
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nom,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 40,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Gap(10),
                      ListView.builder(
                        itemCount: todoData.value?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final todo = todoData.value![index];
                          if (!todo.isDone) {
                            return SizedBox(); // Retourne un widget vide si todoData.isDone est faux
                          }
                          return cardTodoListWidget(getIndex: index);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) =>,
                // ));
              },
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.blue.shade400,
        onTap: (index) {},
      ),
    );
  }

  Future<void> updateUsername(String newUsername) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .update({
          'displayName': newUsername,
        });
        print('Username updated successfully!');
      } catch (e) {
        print('Error updating username: $e');
      }
    } else {
      print('User not logged in.');
    }
  }

  Widget buildTextField(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }
}
