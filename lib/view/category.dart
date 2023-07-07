import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/view/authDetails/profil.dart';
import 'package:todoapp/view/home.dart';

class CategoriesPage extends StatelessWidget {
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('category');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade200,
        elevation: 0,
        title: Text('Categories List'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoriesCollection.snapshots(),
        builder: (context, snapshot) {
          return buildCategoryList(context, snapshot);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD5E8FA),
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: () {
          openAddCategoryDialog(context);
        },
        tooltip: 'Add Category',
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
              icon: Icon(Icons.category),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategoriesPage(),
                ));
              },
            ),
            label: 'Catégories',
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

  Widget buildCategoryList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      final categories = snapshot.data!.docs;

      return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(category['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red.shade100,
                    onPressed: () {
                      // Supprimer la catégorie
                      deleteCategory(category.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.blueAccent.shade100,
                    onPressed: () {
                      // Modifier la catégorie
                      editCategory(context, category);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return CircularProgressIndicator();
    }
  }

  void openAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: Text('Add Category'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Category Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                String categoryName = nameController.text;
                addCategory(categoryName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addCategory(String categoryName) {
    FirebaseFirestore.instance
        .collection('category')
        .add({'name': categoryName});
  }

  void deleteCategory(String categoryId) {
    FirebaseFirestore.instance.collection('category').doc(categoryId).delete();
  }

  void editCategory(BuildContext context, DocumentSnapshot category) {
    TextEditingController nameController =
        TextEditingController(text: category['name']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Category Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String updatedCategoryName = nameController.text;
                updateCategory(category.id, updatedCategoryName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateCategory(String categoryId, String updatedCategoryName) {
    FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .update({'name': updatedCategoryName});
  }
}
