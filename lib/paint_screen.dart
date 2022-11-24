import 'package:drawize/models/my_custom_painter.dart';
//import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:drawize/models/touch_points.dart';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreen extends StatefulWidget {
  final Map<String, String> data;
  final String screenFrom;
  PaintScreen({required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  // String dataRoom = "";

  Map dataOfRoom = {};
  List<TouchPoints> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;
  //created textBlankWidget
  List<Widget> textBlankWidget = [];
  //A member variable to control the scrollable widget.

  ScrollController _scrollController = ScrollController();
//A map of message send and it's sender.
  List<Map> messages = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    connect();
  }
  //function For Chatting
  void renderTextBlank(String text){
    textBlankWidget.clear();
    for (int i=0; i<text.length();i++){
     textBlankWidget.add(const Text('_' ,style:TextStyle(fontsize =30)));
    }


  }

//socket.io client
  void connect() {
    _socket = IO.io('http://10.59.7.155:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();

    //emitting data to index .js

    if (widget.screenFrom == 'createRoom') {
      _socket.emit('create-game', widget.data);
    } else {
      // print(widget.data);
      _socket.emit('join-game', widget.data);
    }

    //listen to socket
    _socket.onConnect((data) {
      print('connected!');
      _socket.on('updateRoom', (roomData) {
        setState(() {
          renderTextBlank(roomData['word']);
          print(roomdata['word']);
          dataOfRoom = roomData;
        });
        if (roomData['isJoin'] != true) {
          //start the timer
        }
      });

      _socket.on('points', (point) {
        // print('takes');
        // print((point['details']['dx']).toDouble());
        if (point['details'] != null) {
          // print((point['details']['dx']).toDouble());
          setState(() {
            points.add(TouchPoints(
                points: Offset((point['details']['dx']).toDouble(),
                    (point['details']['dy']).toDouble()),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = Colors.black.withOpacity(1)
                  ..strokeWidth = 2));
          });
        }
      });
      //Edit by me
      // For listening  to msg widget
      _socket.on('msg', (msgData){
        setState((){
          messages.add(msgData);
        });
        // Adding a feature the length it will scroll upto automatically.
        scrollController.animateTo(_scrollConroller.position.maxScrollExtent+40, duration:Duration(milliseconds:200), curve:Curve.easeInOut);
      });


    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    //void selectColor() {
      //showDialog(context: context, builder: (context) => AlertDialog(
          //title: const Text('Choose Color '),
         //content: SingleChildScrollView(
           //child: BlockPicker(pickerColor: selectedColor, onColorChanged: (color) {
             //String colorString = color.toString();
             //String valueString = colorString.split('(0x')[1].split(')')[0];
             //print(colorString);
             //print(valueString);
            // Map map = {
             //  'color': valueString,
              // 'roomName': dataOfRoom['name']
           // };
             //_socket.emit('color-change', map);
          //})
         //),
      // ));
     //}

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width,
                height: height * 0.55,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    // print(details.localPosition.dx);
                    _socket.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy,
                      },
                      'roomName': widget.data['name'],
                    });
                  },
                  onPanStart: (details) {
                    // print(details.localPosition.dx);
                    _socket.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy,
                      },
                      'roomName': widget.data['name'],
                    });
                  },
                  onPanEnd: (details) {
                    _socket.emit('paint', {
                      'details': null,
                      'roomName': widget.data['name'],
                    });
                  },
                  child: SizedBox.expand(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: RepaintBoundary(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: MyCustomPainter(pointsList: points),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(children: [
                IconButton(
                  icon: Icon(Icons.color_lens, color: selectedColor),
                  tooltip:'Select Your Colour.',
                  onPressed: () {}),
                Expanded(
                  child: Slider(
                      min: 1.0,
                      max: 10,
                      label: "Strokewidth $strokeWidth",
                      activeColor: selectedColor,
                      value: strokeWidth,
                      onChanged: (double value) {
                        Map map = {
                          'value': value,
                          'roomName': dataOfRoom['name']
                        };
                        _socket.emit('stroke-width', map);
                      }),
                ),
                IconButton(
                  icon: Icon(Icons.layers_clear, color: selectedColor),
                  onPressed: () {},
                ),
              ]
            ),//Row
    //edit
          Row(
              mainAxisAlignment :MainAxisAlignment.spaceEvenly(),
              children: textBlankWidget,

    ),
    Container(
    height: MediaQuery.of(context).size.height*0.3,
    child:ListView.builder(
    controller:_scrollController,
    shrinkWrap: true,

    //items we want to accomodate in the container.
    itemCount:messages.length,
    itemBuilder:(context, index){
      var msg = messages[index].values,
      return ListTitle{
        title: Text(
        msg.elementAt(0),
        style: TextStyle(color: Colors.black, fontSize =19, fontWeight = FontWeight.bold ),


        ),
    subtitle: Text(
    msg.elementAt(1),
    style : TextStyle (color : Colors.green, fontSize = 15),
    ),

    }

    }

    )

    )
            ],
          ),
    Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin:EdgeInsects.symmetric(horizontal: 20),
      child: TextField(){

        //So that the user cannot get hints from autocorrect.
        autocorrect:false,
        controller: controller,
        onSubmitted:(value) {
          if (value.trim().isEmpty){
            Map map = {
              'username':widget.data['nickname'],
              'msg'= value.trim(),
              'word' = dataOfRoom['word'],
              'roomname'= widget.data['name'],
    };
    _socket.emit('msg', map);
    controller.clear();
    }
    }
         decoration: InputDecoration(
        border:OutlineInputBorder(
        borderRadius:BorderRadius.circular(8),
        borderSide: const BorderSide(color:Colors.transparent),

    ),
    contentPadding:const EdgeInsects.symmetric(horizontal:16 ,vertical:14),
    filled: true,
    fillColor: const color(0xffF5F5FA),
    hintText: 'Guess the Drawing wisely.',
    hintStyle: const TextStyle(
    fontWeight:FontWeight.w400,
    fontSize: 14,
    ),


        ),
    textInputAction: TextInputAction.done
    }
    )
    )
        ],
      ),
    );
  }
}
