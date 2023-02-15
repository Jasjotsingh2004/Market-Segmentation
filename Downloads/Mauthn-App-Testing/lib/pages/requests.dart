import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mauthn/pages/logs.dart';
import 'package:mauthn/pages/permissions.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import '../pages/camera.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import '../webpages/deviceAttest.dart';

Color MainColor = Color.fromRGBO(114, 118, 252, 1);

// List<CameraDescription> cameras = [];
Timer? timer;
List loggedIn = [];
List req = [];
Widget parseReqData(var data) {
  req = [];
  if (data[0] == "1") req.add("Name");
  if (data[1] == "1") req.add("Date Of Birth");
  if (data[2] == "1") req.add("Image");
  if (data[3] == "1") req.add("Location");
  List<Widget> list = <Widget>[];
  for (var i = 0; i < req.length; i++) {
    list.add(Text("\u2022 " + req[i]));
  }
  if (data == "0000") {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Wants to verify your Identity!",
            // style: TextStyle(color: MainColor),
          ),
        ]);
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Wants to acces your",
          style: TextStyle(color: MainColor),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list,
        ),
      ],
    );
  }
}

String getDialogue(String reqData) {
  String resultantStr = "wants to access your";
  if (reqData[0] == "1") {
    resultantStr += " name, ";
  }
  if (reqData[1] == "1") {
    resultantStr += " Date of Birth, ";
  }
  if (reqData[2] == "1") {
    resultantStr += " Image, ";
  }
  if (reqData[3] == "1") {
    resultantStr += " Location.";
  }

  if (reqData == "0000")
    return "wants to verify your identity";
  else
    return resultantStr;
}

// Future<bool> _launchURLAttest(BuildContext context, String Token) async {
//   try {
//     await launch(
//       // 'https://mauthn.mukham.in/fido_roaming?token=$Token',
//       'https://google.com/',
//       customTabsOption: CustomTabsOption(
//         toolbarColor: Theme.of(context).primaryColor,
//         enableDefaultShare: true,
//         enableUrlBarHiding: true,
//         showPageTitle: true,
//         // animation: CustomTabsAnimation.slideIn(),
//         // // or user defined animation.
//         // animation: const CustomTabsAnimation(
//         //   startEnter: 'slide_up',
//         //   startExit: 'android:anim/fade_out',
//         //   endEnter: 'android:anim/fade_in',
//         //   endExit: 'slide_down',
//         // ),
//         extraCustomTabs: const <String>[
//           // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
//           'org.mozilla.firefox',
//           // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
//           'com.microsoft.emmx',
//         ],
//       ),
//       safariVCOption: SafariViewControllerOption(
//         preferredBarTintColor: Theme.of(context).primaryColor,
//         preferredControlTintColor: Colors.white,
//         barCollapsingEnabled: true,
//         entersReaderIfAvailable: false,
//         dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
//       ),
//     );
//     return true;
//   } catch (e) {
//     return false;
//     // An exception is thrown if browser app is not installed on Android device.
//     // ignore: dead_code
//     debugPrint(e.toString());
//   }
// }

// void _launchURLVerify(BuildContext context, String Token) async {
//   try {
//     await launch(
//       'https://mauthn.mukham.in/fido_platform?token=$Token',
//       customTabsOption: CustomTabsOption(
//         toolbarColor: Theme.of(context).primaryColor,
//         enableDefaultShare: true,
//         enableUrlBarHiding: true,
//         showPageTitle: true,

//         // animation: CustomTabsAnimation.slideIn(),
//         // // or user defined animation.
//         // animation: const CustomTabsAnimation(
//         //   startEnter: 'slide_up',
//         //   startExit: 'android:anim/fade_out',
//         //   endEnter: 'android:anim/fade_in',
//         //   endExit: 'slide_down',
//         // ),
//         // extraCustomTabs: const <String>[
//         //   // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
//         //   'org.mozilla.firefox',
//         //   // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
//         //   'com.microsoft.emmx',
//         // ],
//       ),
//       safariVCOption: SafariViewControllerOption(
//         preferredBarTintColor: Theme.of(context).primaryColor,
//         preferredControlTintColor: Colors.white,
//         barCollapsingEnabled: true,
//         entersReaderIfAvailable: false,
//         dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
//       ),
//     );
//     print("HEllo this will be the request place!!!");
//   } catch (e) {
//     // An exception is thrown if browser app is not installed on Android device.
//     debugPrint(e.toString());
//   }
// }

class Requestor {
  String name;
  String token;
  String reqData;
  String perms;

  Requestor(this.name, this.token, this.reqData, this.perms);

  factory Requestor.fromJson(dynamic json) {
    return Requestor(json['requestor'] as String, json['token'] as String,
        json['reqData'] as String, json['pers'] as String);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.token} }';
  }
}

// void temp_func(BuildContext context) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: ((context) => const deviceAtt(Token: "0000"))));
// }

//   if (perms == "101") {
//     var return_value = await availableCameras().then((value) => Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => camera(
//                   cameras: value,
//                 ))));
//     print(return_value);
//     if (return_value != "") {
//       Future.delayed(const Duration(milliseconds: 9000), () async {
// // Here you can write your code
//         bool temp = await _launchURLAttest(
//             context, "2bd11a8e-8d60-4b16-a133-a08aa49ae1b2");
//         print("yoooo idk whats happening $temp");
//       });
//     }
//   }
// }

Future<String> FetchPage(String id) async {
  final response = await http.post(Uri.parse('https://mauthn.mukham.in/req'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf-8'),
      body: {'id': id});
  if (response.statusCode == 200) {
    print("object");
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

class requests extends StatefulWidget {
  const requests({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<requests> createState() => _requestsState();
}

Color MGrey = Color.fromRGBO(211, 211, 211, 1);

// List listItems = [
//   {
//     "auth": "none",
//     "title": "example.com",
//     "request": "Wants to access your Name, Date of Birth, Location",
//   },
//   {
//     "auth": "none",
//     "title": "demo.com",
//     "request": "Wants to access your Name and Image",
//   },
// ];

class _requestsState extends State<requests> {
  late String jsonStr;
  List listItms = [];
  @override
  // void didChangeDependencies() {
  //   final ThemeData theme = Theme.of(context);
  //   dependOnInheritedWidgetOfExactType();
  //   // _valueColor = _positionController.drive(
  //   //   ColorTween(
  //   //     begin: (widget.color ?? theme.colorScheme.primary).withOpacity(0.0),
  //   //     end: (widget.color ?? theme.colorScheme.primary).withOpacity(1.0),
  //   //   ).chain(CurveTween(
  //   //     curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit),
  //   //   )),
  //   // );
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    super.initState();

    FetchPage(widget.id).then((value) {
      // print(temp[0]);
      // listItms = temp.map((tagJson) => Requestor.fromJson(tagJson)).toList();
      setState(() {
        print(value);
        if (value == "[]") {
          // jsonStr =
          //     '[{"token": "2bd11a8e-8d60-4b16-a133-a08aa49ae1b2", "requester": "example.com", "reqdata": "0000", "perms": "111"}]';
          // var temp = jsonDecode(jsonStr) as List;
          // listItms = temp;
        } else {
          jsonStr = value;
          var temp = jsonDecode(jsonStr) as List;
          listItms = temp;
        }
      });
      timer = Timer.periodic(
          Duration(seconds: 7),
          (Timer t) => FetchPage(widget.id).then((value) {
                print(value);
                setState(() {
                  jsonStr = value;
                  var temp = jsonDecode(jsonStr) as List;
                  listItms = temp;
                });
              }));
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  color: listItms == Null || listItms.length == 0
                      ? Color.fromARGB(255, 214, 236, 253)
                      : MainColor,
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
                  Text("Active"),
                  if (listItms == Null) ...[
                    Text(
                      "0 Requests",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ] else ...[
                    Text("${listItms.length} Requests",
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
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: listItms == Null ? 0 : listItms.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  if (!loggedIn.contains(listItms[index]['token'])) {
                    var temp = await showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialogAuth(
                                context,
                                listItms[index]['reqdata'],
                                listItms[index]['requester'],
                                listItms[index]['token'],
                                listItms[index]['perms']));

                    if (temp) {
                      FetchPage(widget.id).then((value) {
                        // print(temp[0]);
                        // listItms = temp.map((tagJson) => Requestor.fromJson(tagJson)).toList();
                        setState(() {
                          print(value);
                          if (value == "[]") {
                          } else {
                            jsonStr = value;
                            var temp = jsonDecode(jsonStr) as List;
                            listItms = temp;
                          }
                        });
                      });
                    }

                    //                           .then((value) {
                    //                 if (value) {
                    //                   FetchPage(widget.id);
                    //                   .then((value) {
                    // // print(temp[0]);
                    // // listItms = temp.map((tagJson) => Requestor.fromJson(tagJson)).toList();
                    // setState(() {
                    //   print(value);
                    //   if (value == "[]") {
                    //     // jsonStr =
                    //     //     '[{"token": "2bd11a8e-8d60-4b16-a133-a08aa49ae1b2", "requester": "example.com", "reqdata": "0000", "perms": "111"}]';
                    //     // var temp = jsonDecode(jsonStr) as List;
                    //     // listItms = temp;
                    //   } else {
                    //     jsonStr = value;
                    //     var temp = jsonDecode(jsonStr) as List;
                    //     listItms = temp;
                    //   }
                    // });
                    //                 }
                    //                 // setState(() {
                    //                 //   if (value) {
                    //                 //     listItms.removeAt(index);
                    //                 //     loggedIn.add(listItms[index]['token']);
                    //                 //   }
                    //                 // });
                    //               });
                    else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogLog(context));
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: Color.fromRGBO(0, 0, 0, 0.1))),
                  ),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        ImageIcon(
                          AssetImage("assets/pages/lock1.png"),
                          color: Color.fromRGBO(46, 49, 146, 1),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          child: ImageIcon(
                            AssetImage("assets/pages/lock.png"),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    // trailing: Text("data"),
                    title: Text(
                      listItms[index]['requester'],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

//request for auth
Widget _buildPopupDialogAuth(BuildContext context, String reqData, String title,
    String Token, String perms) {
  return AlertDialog(
    title: Text(
      title,
      style: TextStyle(color: MainColor),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(getDialogue(reqData)),
        parseReqData(reqData),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                // _buildPopupDialogAuthSuccess(context, "status");
                Navigator.of(context).pop(false);
              },
              child: Container(
                alignment: AlignmentDirectional.center,
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: MGrey),
                child: Text(
                  "Deny",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                var temp = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Permisiions(
                          title: title,
                          Token: Token,
                          perms: perms,
                        )));

                if (temp == "Success") {
                  Navigator.of(context).pop(true);
                } else {
                  // showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) =>
                  //         _buildPopupDialogAuthSuccess(context, "fail"));
                  Navigator.of(context).pop(false);
                }
                // checkPerms("101", context);
                // Navigator.of(context).pop();
                // listItems[index]['auth'] = "success";
              },
              child: Container(
                alignment: AlignmentDirectional.center,
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: MainColor),
                child: Text(
                  "Okay",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    ),
    actions: <Widget>[
      // new FlatButton(
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      //   textColor: Theme.of(context).primaryColor,
      //   child: const Text('Close'),
      // ),
    ],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}

Widget _buildPopupDialogLog(BuildContext context) {
  return AlertDialog(
    title: Text(
      "Authentication terminated for this request.",
      style: TextStyle(color: MainColor),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: AlignmentDirectional.center,
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: MainColor),
                child: Text(
                  "Okay",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}
