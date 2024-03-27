import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app/Components/line.dart';
import 'package:notes_app/Pages/forgotPassWord_screen.dart';
// import 'package:notes_app/Pages/google_auth.dart';
import 'package:notes_app/Pages/home_screen.dart';
import 'package:notes_app/Pages/signup_screen.dart';

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Đăng nhập thành công, chuyển đến màn hình chính hoặc trang khác
        Get.to(() => HomeScreen());
      } else {
        // Xử lý khi không tạo được tài khoản từ thông tin Google
        print("Không tạo được tài khoản từ thông tin Google.");
      }
    } else {
      // Xử lý khi người dùng từ chối đăng nhập hoặc có lỗi xảy ra
      print("Người dùng từ chối đăng nhập hoặc có lỗi xảy ra.");
    }
  } catch (e) {
    // Xử lý lỗi
    print("Lỗi đăng nhập bằng Google: $e");
  }
}

// ignore: unused_element
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252525),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
            Container(
              width: 250,
              height: 250,
              child: Image.asset('assets/logo.png'),
            ),
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35.0),
              child: TextFormField(
                controller: loginEmailController,
                style: const TextStyle(color: Colors.white),
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
              margin: const EdgeInsets.symmetric(horizontal: 35.0),
              child: TextFormField(
                controller: loginPasswordController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.visibility),
                  suffixIconColor: Colors.white,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        color: Colors.white), // Tắt màu xanh khi được focus
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => const ForgotPassWord(),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 35.0),
                alignment: Alignment.centerRight,
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(35, 30, 35, 30),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  var loginEmail = loginEmailController.text.trim();
                  var loginPassword = loginPasswordController.text.trim();
                  try {
                    final User? firebaseUser = (await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: loginEmail, password: loginPassword))
                        .user;
                    if (firebaseUser != null) {
                      Get.to(() => const HomeScreen());
                    } else {
                      // ignore: avoid_print
                      print('Check mail and pass');
                    }
                  } on FirebaseAuthException catch (e) {
                    print("Error $e");
                  }
                },
                child: const Text("Login"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Line(),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                signInWithGoogle();
              },
              // ignore: avoid_unnecessary_containers
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    )),
                height: 35,
                width: 35,
                child: Padding(
                  padding: const EdgeInsets.all(
                      5.0), // Điều chỉnh khoảng cách giữa viền và hình ảnh
                  child: Image.asset('assets/google.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const SignUpPage());
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
