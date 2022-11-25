import 'package:flutter/material.dart';
import 'create_room_screen.dart';
import 'join_room_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    void howtoplay() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('How To Play!'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                            "1)When it's your turn, choose a word you want to draw!"),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                            "2)Try to draw your choosen word! No spelling!"),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                            "3)Let other players try to guess your drawn word!"),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                            "4)When it's not your turn, try to guess what other players are drawing!"),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                            "5)Score the most points and be crowned the winner at the end!"),
                      ),
                    ],
                  ),
                ),
              ));
    }

    void About() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('About'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                            "1)Group Partners- Himanshu Devatwal, Ayan Minham Khan and Pampa Sow Mondal"),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                            "2)Pictionary- is a free online multiplayer drawing and guessing pictionary game. A normal game consists of a few rounds, where every round a player has to draw their chosen word and others have to guess it to gain points. The person with the most points at the end of the game, will then be crowned as the winner."),
                      ),
                    ],
                  ),
              ),
              ));
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/pencil_colors.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/title.png'),
                    fit: BoxFit.fitWidth)),
            margin: EdgeInsets.only(
                top: 40,
                left: MediaQuery.of(context).size.width * 0.2,
                right: MediaQuery.of(context).size.width * 0.2,
                bottom: MediaQuery.of(context).size.height * 0.7),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'An online drawing and guessing game',
                       maxLines: 3,
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         fontSize: 20,
                         color: Colors.red.shade400,
                       ),
                    ),
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreateRoomScreen(),
                          ),
                        ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.white)),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * .3, 50))),
                    child: const Text(
                      style: TextStyle(fontSize: 20),
                      "Create",
                    )),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const JoinRoomScreen(),
                          ),
                        ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.white)),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * .2, 50))),
                    child: const Text(
                      style: TextStyle(fontSize: 20),
                      "Join",
                    ))
              ],
            ),
          ),
        ]),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  About();
                },
                icon: Icon(Icons.question_mark),
                label: Text("About"),
              ),
              Expanded(child: Container()),
              FloatingActionButton.extended(
                onPressed: () {
                  howtoplay();
                },
                icon: Icon(Icons.colorize),
                label: Text("How To Play!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
