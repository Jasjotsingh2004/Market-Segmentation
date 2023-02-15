import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:mauthn/pages/camera.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../pages/mainPage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/async.dart';


bool retry = false;

bool splashLoad = true;
bool _isloading = false;
Color MainColor = Color.fromRGBO(114, 118, 252, 1);

void _launchURL(BuildContext context) async {
  try {
    await launch(
      'https://mauthn.mukham.in/email-login',
      customTabsOption: CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,

        // animation: CustomTabsAnimation.slideIn(),
        // // or user defined animation.
        // animation: const CustomTabsAnimation(
        //   startEnter: 'slide_up',
        //   startExit: 'android:anim/fade_out',
        //   endEnter: 'android:anim/fade_in',
        //   endExit: 'slide_down',
        // ),
        // extraCustomTabs: const <String>[
        //   // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
        //   'org.mozilla.firefox',
        //   // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
        //   'com.microsoft.emmx',
        // ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
    // return true;
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
  // return false;
}
// class IdStor {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();

//     return directory.path;
//   }

//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/mAuthId');
//   }

//   Future<int> readFile() async {
//     try {
//       final file = await _localFile;

//       // Read the file
//       final contents = await file.readAsString();

//       return int.parse(contents);
//     } catch (e) {
//       // If encountering an error, return 0
//       return 0;
//     }
//   }

//   Future<File> writeFile(String id) async {
//     final file = await _localFile;

//     // Write the file
//     return file.writeAsString('$id');
//   }
// }

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  // print(path);
  return File('$path/id');
}

Future<String> readData() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();
    // print(contents);
    return contents;
  } catch (e) {
    print(e.toString());
    // If encountering an error, return 0
    return "0";
  }
}

Future<File> writeFile(String id) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString('$id');
}

Future<bool> loginReq(String token) async {
  final response = await http.post(Uri.parse('https://mauthn.mukham.in/login'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf-8'),
      body: {'token': token});
  if (response.statusCode == 200) {
    // print("object");
    // print(response.body);
    // print(token);

    if (response.body == "0000") {
      print(response.body);
      return false;
    } else {
      writeFile(response.body);
      return true;
    }
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    // print(response.statusCode);
    // print(response.headers);
    return false;
  }
}

//timer
int _start = 4;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key /*, required this.storage*/}) : super(key: key);
  // final IdStor storage;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //late Image image1;
  final TextEditingController _reasonController = TextEditingController();
  TextEditingController _loginToken = TextEditingController();
  TextEditingController _endDate = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocPerm();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (splashLoad) {
      return Scaffold(
        // body: Center(
        //   child: Image.asset("assets/login/MAuthNLogo.png"),
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 200,
                    child: Image.asset(
                      "assets/login/MAuthNLogo.png",
                    )),
              ),
              SizedBox(
                height: 28,
              ),
              LoadingAnimationWidget.threeArchedCircle(
                  color: MainColor, size: 30)
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Image.asset("assets/login/MAuthNLogo.png")),

                      //sized box to give gap between logo and text box.
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        children: [
                          Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 30),
                                  alignment: AlignmentDirectional.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: TextField(
                                      controller: _loginToken,
                                      onTap: () {},
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter Token here",
                                        prefixIconConstraints: BoxConstraints(
                                          minHeight: 32,
                                          minWidth: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 35,
                                    top: 20,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: 3, left: 10, right: 10),
                                      color: Colors.white,
                                      child: Row(
                                        children: const [
                                          Text(
                                            'Enter Token',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ))
                              ]),
                          SizedBox(
                            width: 160,
                            height: 50,
                            child: FloatingActionButton(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                bool stat = await loginReq(_loginToken.text);
                                print(stat);
                                if (_isloading) return;
                                setState(() {
                                  _isloading = true;
                                  retry = true;
                                });

                                if (stat) {
                                  String Id = await readData();
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    _isloading = false;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              mainPage(id: Id)),
                                      (route) => false,
                                    );
                                  });
                                } else {
                                  _isloading = false;
                                }
                              },
                              backgroundColor: MainColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: (_isloading == true)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                          SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Verifying")
                                        ])
                                  : (retry
                                      ? const Text("Retry")
                                      : const Text("Login")),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 140,
                      ),
                      Column(
                        children: [
                          Text("To get token visit"),
                          InkWell(
                            onTap: () {
                              _launchURL(context);
                            },
                            child: Text(
                              "mauthn.mukham.in/email-login",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 52, 56, 169)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Powered by Mukham",
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  void getState() async {
    var temp = await readData();
    if (temp != "0") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => mainPage(id: temp)),
          (route) => false);
    } else {
      setState(() {
        splashLoad = false;
      });
    }
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);

    sub.onDone(() {
      getState();
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

void getLocPerm() async {
  var status = await Permission.camera.status;
  // if (status.isDenied) {
  // We didn't ask for permission yet or the permission has been denied before but not permanently.
  await Permission.location.request();
  // }
}
