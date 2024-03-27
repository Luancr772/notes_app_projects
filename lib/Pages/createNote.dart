import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/Pages/home_screen.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  TextEditingController noteAddController = TextEditingController();
  User? userId = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252525),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Create Notes"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Container(
              child: TextFormField(
                controller: noteAddController,
                style: const TextStyle(color: Colors.white),
                maxLength: null,
                decoration: const InputDecoration(
                  hintText: "Add note",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var note = noteAddController.text.trim();
                if (note != "") {
                  try {
                    await FirebaseFirestore.instance
                        .collection("notes")
                        .doc()
                        .set(
                      {
                        "CreateAt": DateTime.now(),
                        "note": note,
                        "userId": userId?.uid,
                      },
                    );
                  } catch (e) {
                    // ignore: avoid_print
                    print("Error $e");
                  }
                }
                Get.off(
                  () => const HomeScreen(),
                );
              },
              child: const Text("Add note"),
            )
          ],
        ),
      ),
    );
  }
}
