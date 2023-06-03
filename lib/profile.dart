import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';


class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

  late String username ;
  bool showControls = false;
  List<VideoPlayerController> controllers = [];
  List<String> videoLinks = [
    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];
  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
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

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  Future<String> getUserPhotoUrl(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userInfo = userSnapshot.data()!;
        String photoUrl = userInfo['photoUrl'];
        print(photoUrl);
        return photoUrl;
      } else {
        return 'error not exist';
      }
    } catch (e) {
      print('Error getting user info: $e');
      return 'error get firebase';
    }
  }

  void getUrl() async{
    photoURl = await getUserPhotoUrl(user.email.toString().toLowerCase());
    print('vghjohigufyghjkoihgutfguhijkojihgufydguhjnihugyfctgbhnkbjhgvyf');
    print(photoURl);
  }




  @override
  void initState() {
    email = user.email.toString();
    username = extractNameFromEmail(email);
    setState(() {
      username;
    });

    print(user);
    getUrl();
    setState(() {
      print('22222222222222222222222');
      print(photoURl);
    });
    super.initState();
    controllers = videoLinks
        .map((videoLink) => VideoPlayerController.network(videoLink))
        .toList();
    controllers.forEach((controller) {
      controller.addListener(() {
        if (controller.value.isInitialized) {
          setState(() {});
        }
      });
      controller.setLooping(true);
      controller.initialize().then((_) => setState(() {}));
      controller.pause();
    });
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    // Ouvre la galerie de photos pour que l'utilisateur puisse sélectionner une photo
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Affiche un indicateur de progression
      setState(() {
        _loading = true;
      });

      // Crée une référence de stockage pour la photo
      final fileName = basename(pickedFile.path);
      final storageReference =
      FirebaseStorage.instance.ref().child('images/$fileName');

      // Charge la photo dans le stockage Firebase Storage
      final uploadTask = storageReference.putFile(File(pickedFile.path));
      final taskSnapshot = await uploadTask.whenComplete(() {});

      // Récupère l'URL de téléchargement de la photo
      final photoUrl = await taskSnapshot.ref.getDownloadURL();

      // Met à jour le lien de la photo dans la base de données Firestore
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final userRef = FirebaseFirestore.instance.collection('user').doc(userId);
      await userRef.update({'photoUrl': photoUrl});

      // Met à jour la vue avec la nouvelle photo
      setState(() {
        photoURl = photoUrl;
        _loading = false;
      });
    }
  }



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
