import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_grocery_app/home_screen.dart';
import 'package:smart_grocery_app/inputPrefences.dart';
import 'package:smart_grocery_app/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  //controllers for all of the text box
  final passwordcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();

  @override
  void dispose() {
    // clearing the datqa after used
    emailcontroller.dispose();
    passwordcontroller.dispose();
    usernamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // center body type
        body: Center(
            // to allow the users to be able to scroll if the screen is small
            child: SingleChildScrollView(
                // to allow to take the input
                child: Form(
                    key: formKey,
                    // so everything comes in a column
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 60),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                              // style: TextStyle
                              // collecting username
                              controller: usernamecontroller,
                              obscureText: false,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                hintText: "Enter a username",
                                fillColor: Colors.green[100],
                                filled: true,

                                // username cannot be empty
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  // NOTE: prints out the error message if email is empty
                                  return 'Username cannot be empty';
                                }

                                return null;
                              }),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                              // style: TextStyle
                              // collecting email
                              controller: emailcontroller,
                              obscureText: false,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                hintText: "Enter your email",
                                fillColor: Colors.green[100],
                                filled: true,
                              ),
                              // email cannot be empty
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  // NOTE: prints out the error message if email is empty
                                  return 'Email cannot be empty';
                                }

                                return null;
                              }),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                              // style: TextStyle
                              // collecting password
                              controller: passwordcontroller,
                              obscureText: false,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                hintText: "Enter your Password",
                                fillColor: Colors.green[100],
                                filled: true,
                              ),

                              // text cannot be empty
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  // NOTE: prints out the error message if email is empty
                                  return 'Password cannot be empty';
                                }

                                return null;
                              }),
                        ),

                        const SizedBox(height: 20),
                        // submit button
                        ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  // creating the user
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text,
                                  );

                                  if (mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserInputScreen()),
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  // if th3e password is too weak
                                  if (e.code == 'weak-password') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'The password provided is too weak.')));
                                    // if the email is already in the database
                                  } else if (e.code == 'email-already-in-use') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'The account already exists for that email.')));
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Email and/or password cannot be null")));
                              }
                            },
                            child: const Text("Submit")),

                        const SizedBox(height: 15),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const UserInputScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Already have an account",
                              style: TextStyle(fontSize: 12),
                            )),
                      ],
                    )))));
  }
}
