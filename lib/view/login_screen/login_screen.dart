import 'package:chat/core/service/auth_service.dart';
import 'package:chat/core/widgets/my_button.dart';
import 'package:chat/core/widgets/my_textfield.dart';
import 'package:chat/view/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();
    bool isObscured = false;
    AuthService _authservice = AuthService();

    void obscurePass() {
      setState(() {
        isObscured = !isObscured;
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
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
              'Welcome back you\'ve been missed',
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.primary),
            ),
            //SizedBox
            const SizedBox(height: 40),
            // textfield 0
            MyTextField(
                controller: userNameController,
                hintText: 'Enter your Name',
                labelText: 'Username',
                obscureText: false),
            // textfield 1
            MyTextField(
                controller: emailController,
                hintText: 'Enter your Email',
                labelText: 'Email',
                obscureText: false),
            // textfield 2
            MyTextField(
                controller: passwordController,
                hintText: 'Enter your Password',
                labelText: 'Password',
                suffix: IconButton(
                    onPressed: obscurePass,
                    icon: Icon(
                        isObscured ? Icons.visibility : Icons.visibility_off)),
                obscureText: true),
            // button
            MyButton(
                text: 'Login',
                ontap: () {
                  _authservice.signIn(emailController.text,
                      passwordController.text, userNameController.text);
                }),
            //SizedBox
            const SizedBox(height: 20),
            // register text

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'not a member? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Register Now',
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
    );
  }
}
