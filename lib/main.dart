<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/view/authDetails/auth_checker.dart';
import 'package:todoapp/view/authDetails/error_screen.dart';
import 'package:todoapp/view/authDetails/loading_screen.dart';
=======
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoapp/widget/show_model.dart';
>>>>>>> 6e5253a (setup newest view for addtodo)

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

//  This is a FutureProvider that will be used to check whether the firebase has been initialized or not
final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final initialize = ref.watch(firebaseinitializerProvider);
    return MaterialApp(
<<<<<<< HEAD
      debugShowCheckedModeBanner: false,
      home: initialize.when(
          data: (data) {
            return const AuthChecker();
          },
          loading: () => const LoadingScreen(),
          error: (e, stackTrace) => ErrorScreen(e, stackTrace)),
=======
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
>>>>>>> 6e5253a (setup newest view for addtodo)
    );
  }
}


