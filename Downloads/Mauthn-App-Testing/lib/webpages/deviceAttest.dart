import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:ui';
import 'dart:io';
import 'package:camera/camera.dart';
import '../pages/camera.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

Future _launchURLAttest(BuildContext context, String Token) async {
  try {
    await launch(
      // 'https://mauthn.mukham.in/fido_roaming?token=$Token',
      'https://google.com/',
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
    // return true;
  } catch (e) {
    // return false;
    // // An exception is thrown if browser app is not installed on Android device.
    // // ignore: dead_code
    // debugPrint(e.toString());
  }
  Navigator.pop(context);
}

class deviceAtt extends StatefulWidget {
  final String Token;

  const deviceAtt({Key? key, required this.Token}) : super(key: key);

  @override
  State<deviceAtt> createState() => _deviceAttState();
}

class _deviceAttState extends State<deviceAtt> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
