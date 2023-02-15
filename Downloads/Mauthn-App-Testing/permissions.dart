import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mauthn/pages/camera.dart';
import 'package:mauthn/pages/requests.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'dart:ui';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';

Color MainColor = Color.fromRGBO(114, 118, 252, 1);

Timer? timer1, timer2;

List waitin_state = [0, 0, 0];

List<CameraDescription> cameras = [];

bool doneState = false;

Future<String> FetchPageDeviceQueries(String Token, String url) async {
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf-8'),
      body: {'token': Token});
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

List<bool> confirm_value = [false, false, false];

Future<String> FetchPageCam(
    String Token, String base_64, String location) async {
  final response = await http.post(Uri.parse('https://mauthn.mukham.in/face'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf-8'),
      body: {'token': Token, 'img': base_64, 'location': location});
  if (response.statusCode == 200) {
    // print("object");
    print(response.body);
    return response.body;
    // return true;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.statusCode);
    return ("fail");
    // print(response.headers);
    // print(response.body);
    // return false;
    throw new Exception('Server not reached');
  }
}

Future<bool> _launchURLVerify(BuildContext context, String Token) async {
  try {
    await launch(
      'https://mauthn.mukham.in/fido_platform?token=$Token',
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
    return true;
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
  return false;
}

Future<bool> _launchURLAttest(BuildContext context, String Token) async {
  try {
    await launch(
      'https://mauthn.mukham.in/fido_roaming?token=$Token',
      // 'https://google.com/',
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
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
    return true;
  } catch (e) {
    return false;
    // An exception is thrown if browser app is not installed on Android device.
    // ignore: dead_code
    debugPrint(e.toString());
  }
  return false;
}

Future<String> getLocation() async {
  //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  var lat = 0; //position.latitude;
  var lon = 0; //position.longitude;
  return "$lat,$lon";
}

Future<bool> checkPerms(
    int permsType, BuildContext context, String Token) async {
  var return_value;
  if (permsType == 0) {
    return_value = await availableCameras().then((value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => camera(
                  cameras: value,
                ))));
    // log(return_value);

    String location = await getLocation();
    if (return_value != "" && return_value != "fail") {
      var confirm_val = await FetchPageCam(Token, return_value, location);
      if (confirm_val == "true") {
        return true;
      } //change this later
    }
    // if (return_value) {
    //   var confirm_val = await FetchPageCam(
    //       Token, return_value);
    //   print(confirm_val == "false");
    //   print("the above output is checking the response from server");
    //   return true;
    // }
  }
  if (permsType == 1) {
    // await availableCameras().then((value) => Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => camera(
    //               cameras: value,
    //             ))));
    return_value = await _launchURLVerify(context, Token);
    if (return_value) {
      // var confirm_val = await FetchPageDeviceQueries(
      //     Token, 'https://mauthn.mukham.in/fido_platform_verify');
      if (confirm_value[1]) {
        return true;
      }
    }
    // curl -X POST https://mauthn.mukham.in/fido_platform_verify -H "Content-Type: application/x-www-form-urlencoded" -d "token=9d308706-8d7f-40bb-bc85-635699547997"
  }
  if (permsType == 2) {
    // temp_func(context);

    // await availableCameras().then((value) => Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => camera(
    //               cameras: value,
    //             ))));
    // bool temp =
    return_value = await _launchURLAttest(context, Token);
    if (return_value) {
      // var confirm_val = await FetchPageDeviceQueries(
      //     Token, 'https://mauthn.mukham.in/fido_roaming_verify');
      // print(confirm_val == "false");
      // print("the above output is checking the response from server");
      // print(Token);
      if (confirm_value[2]) {
        return true;
      }
    }
    // print("yoooo idk whats happening $temp");
    // curl -X POST https://mauthn.mukham.in/fido_platform_verify -H "Content-Type: application/x-www-form-urlencoded" -d "token=9d308706-8d7f-40bb-bc85-635699547997"
  }
  return false;
}

class Permisiions extends StatefulWidget {
  const Permisiions(
      {Key? key, required this.Token, required this.perms, required this.title})
      : super(key: key);
  final String title;
  final String perms;
  final String Token;

  @override
  State<Permisiions> createState() => _PermisiionsState();
}

final ListItems = [
  "Facial Recognition",
  "Device Verification",
  "Security Key Verification"
];
List _PermsCheck = [0, 0, 0];

class _PermisiionsState extends State<Permisiions> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitin_state = [0, 0, 0];
    doneState = false;
    _PermsCheck = [0, 0, 0];
    if (widget.perms[2] == "1") {
      timer2 = Timer.periodic(
          Duration(seconds: 3),
          (Timer t) => FetchPageDeviceQueries(widget.Token,
                      'https://mauthn.mukham.in/fido_roaming_verify')
                  .then((value) {
                print(value);
                if (value == "true" && _PermsCheck[2] != 1) {
                  setState(() {
                    _PermsCheck[2] = 1;
                  });
                }
              }));
    }
    if (widget.perms[1] == "1") {
      timer1 = Timer.periodic(
          Duration(seconds: 3),
          (Timer t) => FetchPageDeviceQueries(widget.Token,
                      'https://mauthn.mukham.in/fido_platform_verify')
                  .then((value) {
                print(value);
                if (value == "true" && _PermsCheck[1] != 1) {
                  setState(() {
                    _PermsCheck[1] = 1;
                  });
                }
              }));
    }
  }

  @override
  void dispose() {
    // controller.dispose();
    timer1?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop('fail'),
              child: ImageIcon(
                AssetImage("assets/pages/back_at_verify.png"),
                color: MainColor,
              ),
            )),
      ),
      body: done(_PermsCheck)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.asset("assets/login/MAuthNLogo.png")),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Congrats Login is successful !!!!",
                    style: TextStyle(color: MainColor, fontSize: 18),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.18),
                    child: Text(
                      widget.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      if (widget.perms[index] == "1") {
                        return Container(
                          // width: 20,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    style: BorderStyle.solid,
                                    width: 1,
                                    color: Color.fromRGBO(0, 0, 0, 0.1))),
                          ),
                          child: ListTile(
                            // trailing: Text("data"),
                            leading: ImageIcon(
                              AssetImage("assets/pages/key.png"),
                              color: _PermsCheck[index] == 1
                                  ? Color.fromRGBO(73, 229, 135, 1)
                                  : Color.fromRGBO(228, 18, 5, 1),
                            ),
                            title: Text(ListItems[index]),
                            trailing: (_PermsCheck[index] == 1)
                                ? DoneState()
                                : Container(
                                    margin: EdgeInsets.all(5),
                                    // width: 100,
                                    child: waitin_state[index] == 1
                                        ? LoadingAnimationWidget.waveDots(
                                            color: MainColor, size: 20)
                                        : FloatingActionButton(
                                            heroTag: 'button$index',
                                            backgroundColor: MainColor,
                                            onPressed: () async {
                                              _setAwaiting(index, true);

                                              var temp = await checkPerms(
                                                  index, context, widget.Token);
                                              print(temp);
                                              setState(() {
                                                if (temp) {
                                                  _PermsCheck[index] = 1;
                                                  waitin_state[index] = 0;
                                                } else {
                                                  _PermsCheck[index] = -1;
                                                  waitin_state[index] = 0;
                                                }
                                                if (done(_PermsCheck)) {
                                                  doneState = true;
                                                }
                                              });
                                            },
                                            child: _PermsCheck[index] == -1
                                                ? Text("retry")
                                                : Text("Verify"),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                  ),
                            // trailing: Container(
                            //   width: 15,
                            //   height: 15,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(1000),
                            //     color: listItems[index]['status']
                            //         ? Color.fromARGB(255, 0, 161, 45)
                            //         : Color.fromARGB(255, 215, 27, 27),
                            //   ),
                            // ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10, left: 40, right: 40),
        child: SizedBox(
          // width: MediaQuery.of(context).size.width / 2,
          height: 50,
          child: FloatingActionButton(
            heroTag: 'btmnav',
            onPressed: () {
              if (!waitin_state.contains(1)) {
                if (done(_PermsCheck)) {
                  Navigator.of(context).pop('Success');
                } else {
                  Navigator.of(context).pop('fail');
                }
              }
            },
            child: Text("Done"),
            // focusColor: Colors.black,
            backgroundColor: MainColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }

//empty container

  Container DoneState() {
    return Container(
        margin: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.check,
          color: Color.fromARGB(255, 44, 160, 48),
        ),
        );
  }

  bool done(List permsCheck) {
    if (permsCheck[0].toString() == widget.perms[0]) {
      if (permsCheck[1].toString() == widget.perms[1]) {
        if (permsCheck[2].toString() == widget.perms[2]) {
          return true;
        }
      }
    }
    return false;
  }

  void _setAwaiting(int index, bool state) {
    setState(() {
      waitin_state[index] = state ? 1 : 0;
    });
  }
}
