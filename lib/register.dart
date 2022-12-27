// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_interpolation_to_compose_strings, avoid_print
//Check state
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String emailError = "";
  String passwordError = "";
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMsg = "";
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var mine = Colors.orange;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register " + (user == null ? "Logged Out" : "Logged In"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "New Member",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const Text(
                  "Enter your details to sign up here",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: validateEmail,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    prefixIcon: Icon(Icons.mail),
                  ),
                  controller: emailCtrl,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: validatePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.security_outlined),
                  ),
                  controller: passCtrl,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    errorMsg,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "forgot password ?",
                  style: TextStyle(color: Colors.blueAccent),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: user != null
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (_key.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: emailCtrl.text,
                                            password: passCtrl.text);

                                    setState(() {
                                      errorMsg = "";
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Success"),
                                          content: SizedBox(
                                            height: 150,
                                            child: Center(
                                              child: Text(
                                                  "Registered the email : " +
                                                      emailCtrl.text),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    errorMsg = e.message!;
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                      ElevatedButton(
                        onPressed: user != null
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailCtrl.text,
                                          password: passCtrl.text);

                                  errorMsg = "";
                                } on FirebaseAuthException catch (e) {
                                  errorMsg = e.message!;
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      ElevatedButton(
                        onPressed: user == null
                            ? null
                            : () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                } on FirebaseAuthException catch (e) {
                                  errorMsg = e.message!;
                                }
                                setState(() {});
                              },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
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
    );
  }
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return "Email Address is needed";
  }

  String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(pattern);

  if (!regExp.hasMatch(email)) return "The Email is not in a valid format";
  return null;
}

String? validatePassword(String? pass) {
  if (pass == null || pass.isEmpty) {
    return "Password cannot be empty";
  }

  if (pass.length < 6) {
    return "Must be longer than 6 letters";
  }
/** 
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);

  if (!regExp.hasMatch(pass)) {
    return '''
      Password must be at least 8 letters long contain A symbol
      ,uppercase letter, lowercase letter plus a number to be valid
    ''';
  }

  */
  return null;
}
