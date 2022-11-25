import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitingLobbyScreen extends StatefulWidget {
  final int occupancy;
  final int noOfPlayers;
  final String lobbyName;
  final bool isPartyLeader;
  final players;
  const WaitingLobbyScreen(
      {super.key,
      required this.occupancy,
      required this.noOfPlayers,
      required this.lobbyName,
      required this.isPartyLeader,
      required this.players});

  @override
  State<WaitingLobbyScreen> createState() => _WaitingLobbyScreenState();
}

class _WaitingLobbyScreenState extends State<WaitingLobbyScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final String background;
    final MaterialColor colorCopy;
    final Color colorPrimary;

    if (widget.isPartyLeader) {
      background = 'assets/yellow1.jpg';
      colorCopy = Colors.blue;
      colorPrimary = Colors.white;
    } else {
      background = 'assets/blue1.jpg';
      colorCopy = Colors.yellow;
      colorPrimary = Colors.blueGrey;
    }

    return Container(
      decoration: BoxDecoration(
        image:
            DecorationImage(image: AssetImage(background), fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Waiting for ${widget.occupancy - widget.noOfPlayers} players to join',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.2,
                        right: MediaQuery.of(context).size.width * 0.2),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: const Color(0xffF5F5FA),
                        hintText: 'Tap to copy roomID : ${widget.lobbyName}',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.06,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      //copy room code
                      Clipboard.setData(ClipboardData(text: widget.lobbyName));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('copied!'),
                      ));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorPrimary,
                      backgroundColor: colorCopy,
                    ),
                    child: const Icon(Icons.content_copy),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.1),
            const Text(
              'Players: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              primary: true,
              shrinkWrap: true,
              itemCount: widget.noOfPlayers,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${index + 1}.",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  title: Text(widget.players[index]['nickname'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
