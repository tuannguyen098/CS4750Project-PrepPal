import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_first_flutter_project/HomePage.dart';


class AddRecipes extends StatefulWidget {
  const AddRecipes({super.key, required this.title});

  // This widget is the home page of your application. It i
  // that it has a State object (defined below) that contains
  // how it looks.

  // This class is the configuration for the state. It hold
  // case the title) provided by the parent (in this case t
  // used by the build method of the State. Fields in a Wid
  // always marked "final".

  final String title;

  @override
  State<AddRecipes> createState() => _AddRecipes();
}
class _AddRecipes extends State<AddRecipes> {


  var nameController = TextEditingController();
  var linkController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Add Recipes Page'),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 250, bottom: 25),
                      child: TextField(
                        controller: nameController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child:  TextField(
                        controller: linkController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Link',
                        ),
                      ),
                    ),
                    ElevatedButton(
                        child: const Text("Add Recipe"),
                        onPressed: () {
                            FirebaseFirestore.instance.collection("Recipes").doc("${nameController.text}${FirebaseAuth.instance.currentUser!.uid}").set(
                              {
                                "link": linkController.text,
                                "name": nameController.text,
                                "user": FirebaseAuth.instance.currentUser?.uid,
                              }
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage(title: "HomePage")),
                            );


                        }
                    )
                  ],
                ),
              ),
            ]
        ),
      ),

    );
  }

}