import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/Pages/login_screen.dart';
// import 'package:notes_app/Pages/signup_screen.dart';

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({super.key});

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  TextEditingController forgotpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future passwordReset() async {
      var forgotEmail = forgotpasswordController.text.trim();
      try {
        FirebaseAuth.instance.sendPasswordResetEmail(email: forgotEmail);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                "Password reset link sent! Check your email! Thank you",
              ),
            );
          },
        );
        Get.off(() => const LoginPage());
      } on FirebaseAuthException {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Email is not registered"),
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff252525),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              width: 250,
              height: 250,
              child: Image.asset('assets/logo.png'),
            ),
            const Text(
              'Forgot password',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35.0),
              child: TextFormField(
                controller: forgotpasswordController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(35, 10, 35, 0),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  passwordReset();
                },
                child: const Text("Send"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
