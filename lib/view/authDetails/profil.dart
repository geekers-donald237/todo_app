import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/provider/services_provider.dart';
import 'package:todoapp/view/category.dart';
import 'package:todoapp/view/home.dart';
import 'package:todoapp/widget/cardTodoProfil.dart';

import '../../provider/auth_provider.dart';
import '../../provider/selected_Index_provider.dart';

class Profile extends ConsumerWidget {
  bool showControls = false;
  String? photoURl;
  String email = '';
  File? imageFile;
  bool isEditing = false;
  int selectedIndex = 0;

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
    selectedIndex = ref.watch(selectedIndexProvider);
    int completedTasksCount = 0;
    int incompleteTasksCount = 0;

    final todoData = ref.watch(fetchStreamProvider); // erreur ici
    if (providerId == 'google.com') {
      photoUrl = user!.photoURL.toString();
      nom = user.displayName.toString();
    } else {
      nom = extractNameFromEmail(user!.email.toString());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon profil"),
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
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (value) {
              if (value == 0) {
              } else if (value == 1) {
              } else {
                auth.signOut();
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 0,
                  child:
                      Text("My Account", style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child:
                      Text("Settings", style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Logout", style: TextStyle(color: Colors.white)),
                ),
              ];
            },
            color: Colors.black,
          )
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
                            child: providerId != 'google.com'
                                ? const Image(image: AssetImage('assets/avatar.png'))
                                : Image.network(
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
                        color: Colors.black54,
                        height: 25,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Container(
                        height: 45,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black12,
                              width: 1.0, // Épaisseur de la bordure
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildMenuItem(Icons.pending_actions_outlined,
                                selectedIndex == 0, ref, completedTasksCount),
                            buildMenuItem(Icons.event_available_rounded,
                                selectedIndex == 1, ref, incompleteTasksCount),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: todoData.value?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final todo = todoData.value?[index];
                            final currentUserEmail = user.email;
                            final isCurrentUserParticipant =
                                todo?.participants.contains(currentUserEmail) ??
                                    false;
                            final isDone = todo?.isDone ?? false;

                            if (selectedIndex == 0 &&
                                isCurrentUserParticipant &&
                                !isDone) {
                              incompleteTasksCount++; // Incrémente le nombre de tâches non terminées

                              return CardTodoProfile(getIndex: index);
                            } else if (selectedIndex == 1 &&
                                isCurrentUserParticipant &&
                                isDone) {
                              completedTasksCount; //Incremente e nombres de taches non terminees
                              return CardTodoProfile(getIndex: index);
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
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
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ));
              },
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.category),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategoriesPage(),
                ));
              },
            ),
            label: 'categorie',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.person),
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

  Widget buildMenuItem(
      IconData iconData, bool isSelected, WidgetRef ref, int badgeCount) {
    return GestureDetector(
      onTap: () {
        selectedIndex = [
          Icons.pending_actions_outlined,
          Icons.event_available_rounded,
        ].indexOf(iconData);

        ref
            .read(selectedIndexProvider.notifier)
            .update((state) => selectedIndex);
        print(selectedIndex);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                iconData,
                color: isSelected ? Colors.black87 : Colors.black26,
              ),
              // Positioned(
              //   top: -5,
              //   right: -5,
              //   child: Container(
              //     padding: EdgeInsets.all(4),
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       shape: BoxShape.circle,
              //     ),
              //     child: Text(
              //       badgeCount.toString(),
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 12,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            color: isSelected ? Colors.black : Colors.transparent,
            height: 2,
            width: 55,
          ),
        ],
      ),
    );
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
