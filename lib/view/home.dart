import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/view/category.dart';

import '../provider/auth_provider.dart';
import '../provider/services_provider.dart';
import '../widget/cardTodo.dart';
import '../common/show_model.dart';
import 'authDetails/profil.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  String getEmailPrefix(String email) {
    int atIndex = email.indexOf('@');
    if (atIndex != -1) {
      return email.substring(0, atIndex);
    }
    return email;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(fireBaseAuthProvider);
    User? user = data.currentUser;
    String providerId = user?.providerData[0].providerId ?? '';
    print(providerId);
    String nom;

    if (providerId == 'google.com') {
      nom = user!.displayName.toString();
    } else {
      nom = getEmailPrefix(user!.email.toString());
    }

    String getCurrentDate() {
      final now = DateTime.now();
      final formatter = DateFormat('dd/MM/yy');
      return formatter.format(now);
    }

    String date = getCurrentDate();

    final todoData = ref.watch(fetchStreamProvider); // erreur ici
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: ListTile(
          title: Text(
            "Hello I'm ",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
          subtitle: Text(
            nom,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " ",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  date,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD5E8FA),
                        foregroundColor: Colors.blue.shade800,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "+ New Project?",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              ),
              Gap(10),
              ListView.builder(
                itemCount: todoData.value?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // Récupérer la tâche (todo) à l'index donné
                  final todo = todoData.value?[index];

                  // Vérifier si l'utilisateur actuel est un participant de la tâche
                  final currentUserEmail = user
                      .email; // Remplacez par l'e-mail de l'utilisateur actuel
                  final isCurrentUserParticipant =
                      todo?.participants.contains(currentUserEmail) ?? false;

                  // Afficher uniquement les todos de l'utilisateur actuel
                  if (isCurrentUserParticipant) {
                    return cardTodoListWidget(
                      getIndex: index,
                    );
                  } else {
                    // Retourner un widget vide si l'utilisateur actuel n'est pas un participant de la tâche
                    return SizedBox.shrink();
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD5E8FA),
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              context: context,
              builder: (context) => AddNewTaskModel());
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
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
              icon: Icon(Icons.category_outlined),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategoriesPage(),
                ));
              },
            ),
            label: 'category',
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
        currentIndex: 0,
        selectedItemColor: Colors.blue.shade400,
        onTap: (index) {},
      ),
    );
  }
}
