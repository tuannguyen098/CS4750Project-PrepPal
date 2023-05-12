import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_first_flutter_project/main.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});

  // This widget is the home page of your application. It i
  // that it has a State object (defined below) that contains
  // how it looks.

  // This class is the configuration for the state. It hold
  // case the title) provided by the parent (in this case t
  // used by the build method of the State. Fields in a Wid
  // always marked "final".

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPage();
}
class _SignUpPage extends State<SignUpPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

Widget _buildConfirmError(BuildContext context)
{
  return AlertDialog(
    title: const Text('Sign Up Error'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text("The Confirm Password does not match the Password"),
      ],
    ),
    actions: <Widget>[
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}

  Widget _buildSignUp(BuildContext context)
  {
    return AlertDialog(
      title: const Text('Sign Up Successful'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Your account has been created"),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
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
        title: const Text('Sign Up Page'),
      ),
      body: Column(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          children: [
            Expanded(
              flex:50,
              child: Column(
                children: [
                  Container(
                    margin:  const EdgeInsets.only(top:20, bottom:20),
                    child: const Text(
                        'SignUp',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left:30, right:30, bottom: 10),
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
                    margin: const EdgeInsets.only(left:30, right:30, bottom: 10),
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
                    margin: const EdgeInsets.only(left:30, right:30, bottom: 10),
                    child:  TextField(
                      controller:confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.black
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      child: const Text("SignUp"),
                      onPressed: () {
                        if(passwordController.text != confirmPasswordController.text)
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildConfirmError(context),
                              );
                            return;
                          }
                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                        .then((value){

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage(title: "Login")),
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildSignUp(context),
                          );
                        })
                        .catchError((error){

                        });
                      }
                  )
                ],
              ),
            ),
          ]
      ),

    );
  }

}