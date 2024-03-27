import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/Pages/createNote.dart';
import 'package:notes_app/Pages/editNotes.dart';
// import 'package:notes_app/Pages/google_auth.dart';
// import 'package:notes_app/Pages/google_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app/Pages/login_screen.dart';
import 'package:notes_app/Pages/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> noteColors = [
    const Color(0xFD99FFff),
    const Color(0xFF9E9E9E),
    const Color(0x91F48F8F),
    const Color(0xFFF59999),
    const Color(0x9EFFFFFF),
    const Color(0xB69CFFFF),
    // Thêm các màu khác nếu bạn muốn
  ];
  var random = Random();
  get randomColor => noteColors[random.nextInt(noteColors.length)];
  User? userId = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    // Kiểm tra xem currentUser có tồn tại hay không
    if (currentUser != null) {
      // Lấy đường dẫn đến ảnh đại diện
      String? photoURL = currentUser.photoURL;

      // Kiểm tra xem photoURL có giá trị hay không
      if (photoURL != null && photoURL.isNotEmpty) {
        // Sử dụng photoURL như là đường dẫn đến ảnh đại diện
        print("Đường dẫn đến ảnh đại diện: $photoURL");
      } else {
        // Nếu không có ảnh đại diện, bạn có thể thực hiện một xử lý khác
        print("Không có ảnh đại diện");
      }
    }

    void showProfilePopupMenu() {
      showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(100.0, 80.0, 0.0, 0.0),
        items: [
          const PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(
                  Icons.person,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Profile",
                ),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text("Log out"),
              ],
            ),
          ),
        ],
      ).then((value) {
        if (value == 'profile') {
          // Xử lý khi chọn "Hồ sơ"
          Get.to(() => const Profile());
        } else if (value == 'logout') {
          FirebaseAuth.instance.signOut();
          GoogleSignIn().signOut();
          Get.off(() => const LoginPage());
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xff252525),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Notes"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () async {
                showProfilePopupMenu();
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser?.photoURL ?? '',
                ),
                radius: 15,
              ),
            ),
          )
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("notes")
              .where("userId", isEqualTo: userId?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              // ignore: avoid_unnecessary_containers
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/rafiki.png'),
                      const Text(
                        "Create Your First Note",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                ),
              );
            }

            // ignore: unnecessary_null_comparison
            if (snapshot != null && snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var note = snapshot.data!.docs[index]['note'];
                    var timestamp =
                        snapshot.data!.docs[index]['CreateAt'] as Timestamp;
                    var date = timestamp.toDate();
                    var formattedDate =
                        DateFormat('dd-MM-yyyy HH:mm').format(date);
                    var docId = snapshot.data!.docs[index].id;
                    return Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: randomColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: ListTile(
                        title: Text(
                          note,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => const EditNote(),
                                  arguments: {
                                    'note': note,
                                    'docId': docId,
                                  },
                                );
                              },
                              child: const Icon(Icons.edit),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('notes')
                                    .doc(docId)
                                    .delete();
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreateNote());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
