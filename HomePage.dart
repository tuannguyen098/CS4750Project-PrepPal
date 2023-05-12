import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_first_flutter_project/AddRecipesPage.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_first_flutter_project/main.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});


  // This widget is the home page of your application. It i
  // that it has a State object (defined below) that contains
  // how it looks.

  // This class is the configuration for the state. It hold
  // case the title) provided by the parent (in this case t
  // used by the build method of the State. Fields in a Wid
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePage();
}
class _HomePage extends State<HomePage> {

  final Stream<QuerySnapshot> _RecipesStream = FirebaseFirestore.instance.collection('Recipes').snapshots();
  bool _searchBoolean = false;
  List<int> _searchIndexList = [];
  List recipesList= [];
  List searchRecipesList = [];

  Widget _searchTextField() {
    return TextField(
      autofocus: true, //Display the keyboard when TextField is displayed
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search, //Specify the action button on the keyboard
      decoration: const InputDecoration( //Style of TextField
        enabledBorder: UnderlineInputBorder( //Default TextField border
            borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: UnderlineInputBorder( //Borders when a TextField is in focus
            borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: TextStyle( //Style of hintText
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
        onChanged: (String s) { //add
          setState(() {
            _searchIndexList = [];
            for (int i = 0; i < searchRecipesList.length; i++) {
              if ((searchRecipesList[i].toLowerCase()).contains(s.toLowerCase())) {
                _searchIndexList.add(i);
              }
            }
          }
    );
  });
  }

  Widget _searchListView() {
    return ListView.builder(
        itemCount: _searchIndexList.length,
        itemBuilder: (context, index) {
          index = _searchIndexList[index];
          return Card(
              child: ListTile(
                  title: Text(searchRecipesList[index]),
                  onTap: () async {
                    Uri url = Uri.parse('${recipesList[index]['link']}');
                    if(await canLaunchUrl(url)){
                      await launchUrl(url);
                      }else {
                        throw 'Could not launch $url';
                    }
                },
              )
          );
        }
    );
  }

  Widget _defaultListView() {
    return Stack(
        children: [
          Center(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: recipesList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 70,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: [
                                      Text('${recipesList[index]['name']}'),
                                    ],
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Choose an Option"),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      onPressed: ()
                                      async {
                                        Uri url = Uri.parse('${recipesList[index]['link']}');
                                          if(await canLaunchUrl(url)){
                                              await launchUrl(url);
                                             }
                                          else {
                                            throw 'Could not launch $url';
                                          }
                                      },
                                      child: const Text("Open Recipe Link")),
                                  ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance.collection("Recipes").doc("${recipesList[index]['name']}${FirebaseAuth.instance.currentUser!.uid}").delete();

                                        recipesList.removeAt(index);
                                        searchRecipesList.removeAt(index);
                                        setState((){
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete Saved Recipe")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Go Back")),
                                ],
                              ),
                          ),
                        );
                      },
                    );

                  },

                );
              },

            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
                child: const Icon(Icons.logout_outlined),
                onPressed: () async
                {
                  await _signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(title: 'Login Page'),
                    ),
                  );
                }
            ),
          ),
        ]
    );
  }


  void loadAllRecipesFromFirebase()
  {
    int index = 0;
    FirebaseFirestore.instance.collection("Recipes").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
              var data = docSnapshot.data();
              if(FirebaseAuth.instance.currentUser?.uid == (data["user"])){
                recipesList.add(docSnapshot);
                searchRecipesList.add(recipesList[index]['name']);
                setState(() {});
                index++;
              }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );


  }
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder<QuerySnapshot>(
          stream: _RecipesStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: !_searchBoolean ? Text(widget.title) : _searchTextField(),
                actions: !_searchBoolean
                    ?[
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = true;
                          _searchIndexList = [];
                        });
                      })
                    ]
                    :[
                  IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = false;
                        });
                      }
                  )
                ],
              ),
              body: !_searchBoolean ? _defaultListView() : _searchListView(),
              floatingActionButton: FloatingActionButton(
                tooltip: 'Add Recipe',
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const AddRecipes(title: "AddRecipesPage")),
                  );
                },
              ),


            );
},

      ),
    );

  }

  void initState(){
    super.initState();
    loadAllRecipesFromFirebase();
  }
}