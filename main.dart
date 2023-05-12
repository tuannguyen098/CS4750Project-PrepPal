import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_first_flutter_project/HomePage.dart';
import 'package:my_first_flutter_project/SignUpPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrepPal',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(title: 'PrepPal'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  // This widget is the home page of your application. It i
  // that it has a State object (defined below) that contains
  // how it looks.

  // This class is the configuration for the state. It hold
  // case the title) provided by the parent (in this case t
  // used by the build method of the State. Fields in a Wid
  // always marked "final".

  final String title;

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var resetController = TextEditingController();

  Widget _buildLoginError(BuildContext context)
  {
    return AlertDialog(
      title: const Text('Login Error'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text('Your Email or Password is incorrect'),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            resetController.clear();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }


  Widget _buildConfirmSent(BuildContext context)
  {
    return AlertDialog(
      title: const Text('Password Reset Email Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("The Reset Password Email Has Been Sent"),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginPage(title: "Login Page")),
            );
          },
          child: const Text('Close'),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    //bool _isSigningIn = false;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

          appBar: AppBar(
            centerTitle: true,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Text('PrepPal'),
          ),

          body: SingleChildScrollView(
            child: Column(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              children: [
                Container(
                  margin: const EdgeInsets.only(top:10),
                  child: const SizedBox(
                    height:200,
                    child:Image(
                      image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPWDU2v8ciH7i4TC09zEUIf-O-rSHiEwWybjAQNDlG&s"),
                      fit:BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          )
                          ),
                      Container(
                        margin: const EdgeInsets.only(bottom:10),
                        child: TextField(
                          controller: emailController,
                          obscureText: false,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.black
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom:20),
                        child:  TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                color: Colors.black
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom:10),
                        child: TextButton(
                           child: const Text('Forgot Password?',
                          style: TextStyle(color: Colors.red)
                           ),
                          onPressed: ()
                          {
                          showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Forgot Password?'),
                              content: TextField(
                                controller: resetController,
                                decoration: const InputDecoration
                                (
                                  hintStyle: TextStyle(
                                      color: Colors.black
                                  ),
                                  border: OutlineInputBorder(),
                                labelText: 'Email',),
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  child: const Text('Confirm'),
                                  onPressed: ()
                                  {
                                      FirebaseAuth.instance.sendPasswordResetEmail(email: resetController.text).whenComplete(() =>
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => _buildConfirmSent(context),
                                          )
                                      );
                                  }
                                ),
                              ],
                            );
                          });
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom:10),
                        child: ElevatedButton(

                          child: const Text("Login"),

                          onPressed: () {
                            FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                                .then((value){
                              print("Login Complete!");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => const HomePage(title: "HomePage")),
                                  ModalRoute.withName('/')
                              );
                              print(FirebaseAuth.instance.currentUser);
                            })
                                .catchError((error){
                              print("Sign Up Failed");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildLoginError(context),
                              );
                            });


                          }
                        ),
                      ),
                      ElevatedButton(
                          child: const Text("Sign Up"),
                          onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage(title: "SignUpPage")),
                              );
                            })


                    ],
                  ),
                ),

                ]
            ),
          ),

      ),
    );
  }

}