import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mauthn/pages/camera.dart';

Timer? timer;

Color MainColor = Color.fromRGBO(114, 118, 252, 1);

List<String> MonList = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

Future<String> FetchPage(String id) async {
  final response = await http.post(Uri.parse('https://mauthn.mukham.in/logs'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf-8'),
      body: {'id': id});
  if (response.statusCode == 200) {
    // print("object");
    print(response.body);
    return response.body;
    // return true;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.statusCode);
    // print(response.headers);
    // print(response.body);
    // return false;
    throw new Exception('Server not reached');
  }
}

class logs extends StatefulWidget {
  const logs({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<logs> createState() => _logsState();
}

// List listItems = [
//   {"title": "example.com", "status": true},
//   {"title": "demo.com", "status": false},
// ];

class _logsState extends State<logs> {
  late String jsonStr;
  List listItems = [];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 7),
        (Timer t) => FetchPage(widget.id).then((value) {
              print(value);
              setState(() {
                jsonStr = value;
                var temp = jsonDecode(jsonStr) as List;
                listItems = temp;
              });
            }));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (listItems.length > 0) {
      return Column(


        //we use this property as we are adding a scrollable widget(list view bulder to a column which has a definite size)
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          SizedBox(
            height: 90,
          ),
          Stack(

            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, value, _) => CircularProgressIndicator(
                    value: value,
                    strokeWidth: 30,
                    backgroundColor: Color.fromARGB(255, 214, 236, 253),
                    color: MainColor,
                    // semanticsLabel: "Yooooooooo",
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 150,
                child: Column(


                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text("Active"),
                    if (listItems == Null) ...[
                      Text(
                        "0 Requests",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ] else ...[
                      Text("${listItems.length} \n Successful",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ]
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 18,
          ),
          //flexible to not cause all items inside to warp space
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              itemCount: listItems.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildPopupDialog(
                      context,
                      listItems[index]['requester'],
                      listItems[index]['timestamp'],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: Color.fromRGBO(0, 0, 0, 0.1))),
                    ),
                    child: ListTile(
                      leading: Container(
                        margin: EdgeInsets.only(top: 4),
                        child: ImageIcon(
                          AssetImage("assets/pages/key.png"),
                          color: Color.fromARGB(255, 23, 23, 23),
                        ),
                      ),
                      // trailing: Text("data"),
                      title: Text(listItems[index]['requester']),

                      // trailing: Container(
                      //   // width: 15,
                      //   // height: 15,
                      //   // decoration: BoxDecoration(
                      //   //   borderRadius: BorderRadius.circular(1000),
                      //   //   color: listItems[index]['status']
                      //   //       ? Color.fromARGB(255, 0, 161, 45)
                      //   //       : Color.fromARGB(255, 215, 27, 27),
                      //   // ),
                      //   child: Text(listItems[index]['timestamp']),
                      // ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.inkDrop(color: MainColor, size: 200),
          SizedBox(
            height: 40,
          ),
          Text(
            "Waiting for Logs to be generated.....",
            style: TextStyle(fontSize: 20),
          )
        ],
      ));
    }
  }
}

Widget _buildPopupDialog(BuildContext context, String title, String timestamp) {
  return AlertDialog(
    alignment: AlignmentDirectional.center,
    title: Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: MainColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
            child: Text(
          "was granted access on",
          textAlign: TextAlign.center,
        )),
        Center(
            child: Text(
          timestamp,
          textAlign: TextAlign.center,
        )),
      ],
    ),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: FloatingActionButton.extended(
                // child: Text("Okay"),
                label: Text("Okay", style: TextStyle(fontSize: 18)),
                backgroundColor: MainColor,
                elevation: 0,
                // shape: ,
                heroTag: "exitDialogue0",
                onPressed: () => Navigator.of(context).pop())),
      )
    ],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}
