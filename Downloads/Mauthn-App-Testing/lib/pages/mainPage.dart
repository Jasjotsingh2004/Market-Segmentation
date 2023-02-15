import 'package:flutter/material.dart';
import '../widgets/NavigationDrawer.dart';
import 'package:mauthn/login/loginPage.dart';
import '../theme.dart';
import '../pages/requests.dart';
import '../pages/logs.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:ui';
import 'dart:io';

Color MainColor = Color.fromRGBO(114, 118, 252, 1);

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  // print(path);
  return File('$path/id');
}

class mainPage extends StatefulWidget {
  const mainPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<mainPage> createState() => _mainPageState();
}

const double width = 246.0;
const double height = 44.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.black54;
var pageNo = 0;

class _mainPageState extends State<mainPage> {
  late double xAlign;
  late Color loginColor;
  late Color signInColor;
  late String json;
  late List pages;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    print(widget.id);
    pages = [
      requests(
        id: widget.id,
      ),
      logs(id: widget.id),
    ];
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  bool toggleValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),


      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: SizedBox(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // InkWell(
              //   onTap: () => _key.currentState!.openDrawer(),
              //   child: Container(
              //     margin: EdgeInsets.only(top: 5),
              //     child: ImageIcon(
              //       AssetImage("assets/pages/Vector.png"),
              //       color: MainColor,
              //     ),
              //   ),
              // ),

              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: height,
                margin: EdgeInsets.fromLTRB(50, 5, 50, 0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(46, 49, 146, 0.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: Alignment(xAlign, 0),
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: width * 0.5,
                        height: height + 0.5,
                        decoration: BoxDecoration(
                          color: MainColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(

                      onTap: () {
                        setState(() {
                          xAlign = loginAlign;
                          loginColor = selectedColor;
                          pageNo = 0;
                          signInColor = normalColor;
                        });
                      },
                      child: Align(
                        alignment: Alignment(-1, 0),
                        child: Container(
                          width: width * 0.5,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'Requests',
                            style: TextStyle(
                              color: loginColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          xAlign = signInAlign;
                          signInColor = selectedColor;

                          pageNo = 1;
                          loginColor = normalColor;
                        });
                      },
                      child: Align(
                        alignment: Alignment(1, 0),
                        child: Container(
                          width: width * 0.5,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            'Logs',
                            style: TextStyle(
                              color: signInColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: pages[pageNo],
      drawer: NavigationDrawer(
        id: widget.id,
      ),
    );
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }
}


Widget ShowLogoutDialogue(BuildContext context) {
  return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0))),
      title: Text(
        "Logout",
        style: TextStyle(color: MainColor, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Do you Really want to logout?"),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: MainColor,
                ),
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);

                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: MainColor,
                ),
                child: Text("Logout"),
                onPressed: () async {
                  File temp = await _localFile;
                  temp.delete();
                  // ignore: use_build_context_synchronously

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          ),
        ],
      ));
}
