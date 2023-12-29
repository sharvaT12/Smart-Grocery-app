import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smart_grocery_app/services/api.dart';
import 'package:smart_grocery_app/signup_screen.dart';
import 'home_screen.dart';
import 'models/recipe_plan.dart';

void main() async {
  // NOTE: we need to initialize the firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = new GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool setObsecureText = true;

  void _showHomeScreen() async {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,

          // NOTE: the form Column
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              'Welcome back!',
              style: TextStyle(fontSize: 40),
            ),

            SizedBox(height: 15),

            // NOTE: user input email
            SizedBox(
              width: 300,
              child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Enter email: ", border: OutlineInputBorder()),

                  // NOTE: adding validation logic
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // NOTE: prints out the error message if email is empty
                      return 'Email cannot be empty';
                    }
                    return null;
                  },

                  // NOTE: this will give control to the emailController (because we want to have the TextEditing part in this case)
                  controller: emailController),
            ),

            // NOTE: spacing between the inputs
            const SizedBox(height: 15),

            // NOTE: user input password
            SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: InputDecoration(

                      // NOTE: for the eye icon (to see password or hide it)
                      suffixIcon: IconButton(
                        icon: setObsecureText
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          // NOTE: while it refreshes the widgets, we assign the obsecure text to the opposite value
                          setState(() {
                            setObsecureText = !setObsecureText;
                          });
                        },
                      ),
                      labelText: "Enter password: ",
                      border: OutlineInputBorder()),

                  // NOTE: sets the obsecureText to that current boolean
                  obscureText: setObsecureText,

                  // NOTE: adding validation logic
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // NOTE: prints out the error message if password is empty
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  controller: passwordController,
                )),

            SizedBox(height: 15),

            ElevatedButton(
                onPressed: () async {
                  // NOTE: checks if the form entered is valid or not
                  if (formKey.currentState!.validate()) {
                    // Connect to firebase for user authentication
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);

                      _showHomeScreen();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('No user found for that email!')));
                      } else if (e.code == 'wrong-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Wrong password provided for that user!')));
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Email and/or password cannot be null")));
                  }
                },
                child: const Text("Login")),

            const SizedBox(height: 15),

            TextButton(
                onPressed: () {
                  // NOTE: goes to the sign up screen if not registered yet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  "Create an Account!",
                )),
          ]),
        ),
      ),
    ));
  }
}
