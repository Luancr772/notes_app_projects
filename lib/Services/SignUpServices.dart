import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/Pages/login_screen.dart';

SignUpUser(String userName, String userPhone, String userEmail,
    String userPassword) async {
  User? userid = FirebaseAuth.instance.currentUser;
  try {
    await FirebaseFirestore.instance.collection("user").doc(userid!.uid).set({
      'username': userName,
      'userphone': userPhone,
      'email': userEmail,
      'createAt': DateTime.now(),
    }).then((value) => {
          FirebaseAuth.instance.signOut(),
          Get.to(
            () => const LoginPage(),
          )
        });
  } on FirebaseAuthException catch (e) {
    // ignore: avoid_print
    print("Error $e");
  }
}
