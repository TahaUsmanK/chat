import 'package:chat/core/service/auth_service.dart';
import 'package:chat/core/widgets/my_button.dart';
import 'package:chat/core/widgets/my_textfield.dart';
import 'package:chat/view/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    AuthService _authservice = AuthService();
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
                obscureText: true),
            // button
            MyButton(
                text: 'Login',
                ontap: () {
                  _authservice.signIn(
                      emailController.text, passwordController.text);
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
