import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mauthn/pages/camera.dart';
import 'package:qr_flutter/qr_flutter.dart';

Timer? timer;

Color MainColor = Color.fromRGBO(114, 118, 252, 1);

Future<String> FetchPage(String id) async {
  final response =
      await http.post(Uri.parse('https://mauthn.mukham.in/get_iot'),
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

class iotServices extends StatefulWidget {
  const iotServices({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<iotServices> createState() => _iotServicesState();
}

class _iotServicesState extends State<iotServices> {
  late String jsonStr;
  int iotCode = 0;

  @override
  void initState() {
    super.initState();
    FetchPage(widget.id).then((value) {
      print(value);
      setState(() {
        jsonStr = value;
        var temp = jsonDecode(jsonStr) as int;
        iotCode = temp;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (iotCode != 0) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "MAuthN",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "IoT Login",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 18,
              ),
              QrImage(
                data: iotCode.toString(),
                size: 200,
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(
                    100,
                    100,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Scan the QR Code",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "Or",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "use the code",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                iotCode.toString(),
                style: TextStyle(fontSize: 28),
              )
            ],
          ),
        ),
        bottomNavigationBar: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Powered By Mukham",
              style: TextStyle(color: Colors.black54),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.inkDrop(color: MainColor, size: 200),
            SizedBox(
              height: 40,
            ),
            Text(
              "Waiting for QR to be generated.....",
              style: TextStyle(fontSize: 20),
            )
          ],
        )),
      );
    }
  }
}
