import 'dart:html';

import 'package:drawize/home_screen.dart';
import 'package:drawize/paint_screen.dart';
import 'package:drawize/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  void joinRoom() {
    Map<String, String> data = {
      "nickname": _nameController.text,
      "name": _roomNameController.text,
    };
    // print(data);
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaintScreen(
              data: data,
              nickname: _nameController.text.trim(),
              screenFrom: 'joinRoom',
              isPartyLeader: false)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/blue1.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Join Room",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: 'Enter your name',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _roomNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: 'Enter Room ID',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: joinRoom,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(231, 187, 61, 0.9)),
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(color: Colors.white)),
                  minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width / 2.5, 50))),
              child: const Text(
                "Join",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            CircleAvatar(
                radius: 32,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.greenAccent,
                  child: IconButton(
                    color: Colors.black,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
