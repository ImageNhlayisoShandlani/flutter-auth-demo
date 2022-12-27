// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String t = "Login Page";
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Login Here",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
            Text(
              "Enter details to login here",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email Address",
                prefixIcon: Icon(Icons.email_sharp),
              ),
              controller: emailController,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.security_outlined),
                ),
                controller: passController),
            SizedBox(
              height: 20,
            ),
            Text(
              "forgot password ?",
              style: TextStyle(color: Colors.blueAccent),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () async {
                  try {
                    final user = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passController.text);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      print(e.code);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Email Error"),
                            content: SizedBox(
                              height: 300,
                              child: Center(
                                child: Text(e.code),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {},
                                child: Text("OK"),
                              )
                            ],
                          );
                        },
                      );
                    } else if (e.code == 'weak-password') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Password Error"),
                            content: SizedBox(
                              height: 250,
                              child: Center(
                                child: Text(
                                  e.code,
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              )
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                fillColor: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(12),
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
