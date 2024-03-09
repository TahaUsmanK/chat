import 'package:chat/core/service/auth_service.dart';
import 'package:chat/core/widgets/my_button.dart';
import 'package:chat/core/widgets/my_textfield.dart';
import 'package:chat/view/home_screen/home_screen.dart';
import 'package:chat/view/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmpasswordController =
        TextEditingController();
    final TextEditingController userNameController = TextEditingController();
    AuthService _authservice = AuthService();
    bool isObscured = false;
    void obscurePass() {
      setState(() {
        isObscured = !isObscured;
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon
              Icon(
                Icons.message_outlined,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),

              // text
              Text(
                'Let\'s create an account for you',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
              //SizedBox
              const SizedBox(height: 40),
              // textfield 1
              MyTextField(
                  controller: userNameController,
                  hintText: 'Enter your Name',
                  labelText: 'Username',
                  obscureText: false),
              // textfield 2
              MyTextField(
                  controller: emailController,
                  hintText: 'Enter your Email',
                  labelText: 'Email',
                  obscureText: false),
              // textfield 3
              MyTextField(
                  controller: passwordController,
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  suffix: IconButton(
                    onPressed: () {
                      obscurePass();
                    },
                    icon: Icon(
                        isObscured ? Icons.visibility : Icons.visibility_off),
                  ),
                  obscureText: true),
              // textfield 4
              MyTextField(
                  controller: confirmpasswordController,
                  hintText: 'Confirm your Password',
                  labelText: 'Confirm Password',
                  suffix: IconButton(
                    onPressed: () {
                      obscurePass();
                    },
                    icon: Icon(
                        isObscured ? Icons.visibility : Icons.visibility_off),
                  ),
                  obscureText: true),
              // button
              MyButton(
                text: 'Register',
                ontap: () {
                  if (passwordController.text ==
                      confirmpasswordController.text) {
                    try {
                      _authservice.signUp(emailController.text,
                          passwordController.text, userNameController.text);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    } on FirebaseAuthException catch (error) {
                      if (error.code == 'email-already-in-use') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Email Already Exists'),
                              content:
                                  Text('The email address is already in use.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Sign Up Error'),
                              content: Text(
                                  'An error occurred during registration. Please try again.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Password Mismatch'),
                          content: Text('The passwords entered do not match.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),

              //SizedBox
              const SizedBox(height: 20),
              // Login text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'already a member? ',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Login Now',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
