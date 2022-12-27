// ignore_for_file: prefer_const_literals_to_create_immutables

import 'register.dart';

import 'login.dart';
import 'package:flutter/material.dart';

class EntryScreen extends StatelessWidget {
  EntryScreen({super.key});

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 79, 68, 177),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Welcome to the app pick action",
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Login();
                        },
                      ),
                    );
                  },
                  child: const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Register();
                        },
                      ),
                    );
                  },
                  child: const Text("Register"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
