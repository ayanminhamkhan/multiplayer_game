import 'package:drawize/home_screen.dart';
import 'package:drawize/paint_screen.dart';
import 'package:drawize/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  String? _maxRoundsValue;
  String? _maxSizeValue;

  void createRoom() {
    Map<String, String> data = {
      "nickname": _nameController.text.trim(),
      "name": _roomNameController.text.trim(),
      "occupancy": _maxSizeValue!,
      "maxRounds": _maxRoundsValue!,
    };
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _maxRoundsValue != null &&
        _maxSizeValue != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaintScreen(
                data: data,
                nickname: _nameController.text.trim(),
                screenFrom: 'createRoom',
                isPartyLeader: true,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/yellow1.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create Room",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.2,
                  right: MediaQuery.of(context).size.width * 0.2),
              child: Column(
                children: [
                  TextField(
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
                    controller: _nameController,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
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
                      controller: _roomNameController),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.35,
                  right: MediaQuery.of(context).size.width * 0.35),
              child: Column(
                children: [
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      // labelText: 'Select Room Size'
                    ),
                    dropdownColor: Colors.white,
                    value: _maxRoundsValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _maxRoundsValue = newValue;
                      });
                    },
                    items: <String>['2', '3', '4', '5', '10', '15', '20']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: const Text('Select Max Rounds',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      // labelText: 'Select Room Size'
                    ),
                    dropdownColor: Colors.white,
                    value: _maxSizeValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _maxSizeValue = newValue;
                      });
                    },
                    items: <String>['2', '3', '4', '5', '6', '7', '8']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: const Text('Select Room Size',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: createRoom,
              style: ElevatedButton.styleFrom(
                  side: const BorderSide(width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: const Color.fromRGBO(33, 147, 234, 0.9),
                  textStyle: (const TextStyle(color: Colors.white)),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width / 2.5, 50)),
              child: const Text(
                "Create",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
