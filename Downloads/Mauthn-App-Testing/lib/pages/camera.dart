// import 'dart:html';
import 'dart:async';
import 'dart:developer';
import 'dart:io' as importer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as Img;

Color MainColor = Color.fromRGBO(114, 118, 252, 1);

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

class camera extends StatefulWidget {
  const camera({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;
  @override
  State<camera> createState() => _cameraState();
}

Future<String> get _localFile async {
  final path = await _localPath;
  // print(path);
  return '$path/temp.jpg';
}

Future<importer.File?> testCompressAndGetFile(
    File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, targetPath,
    quality: 80,
    // rotate: 180,
  );

  print(file.lengthSync());
  print(result?.lengthSync());

  return result;
}

String ImagePath = "";
String base64string = "";

Color MGrey = Color.fromRGBO(211, 211, 211, 1);
int img = 0;
bool cap_vis = true;

class _cameraState extends State<camera> {
  late CameraController controller;
  XFile? pictureFile;

  @override
  void initState() {
    cap_vis = true;
    super.initState();
    controller = CameraController(widget.cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            importer.File(ImagePath).delete();
            Navigator.of(context).pop('fail');
          },
        ),
        centerTitle: true,
        title: const Text('Take a picture'),
        backgroundColor: MainColor,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: MainColor,
            border: Border(
                bottom: BorderSide(width: 1, color: MainColor),
                top: BorderSide(width: 1, color: MainColor))),
        child: Stack(
          children: [
            if (cap_vis) ...[
              Container(
                width: MediaQuery.of(context).size.width,
                child: CameraPreview(controller),
              ),
            ] else ...[
              Container(
                child: Image.file(importer.File(ImagePath)),
              )
            ],
            Container(
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.transparent),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                  child: Container(
                decoration: BoxDecoration(
                    color: MainColor,
                    border: Border(
                        bottom: BorderSide(width: 1, color: MainColor),
                        top: BorderSide(width: 1, color: MainColor))),
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Visibility(
                          visible: !cap_vis,
                          child: FloatingActionButton(
                            heroTag: 'reset',
                            onPressed: () {
                              importer.File(ImagePath).delete();
                              // if (img == 0) {
                              //   img = 1;
                              // } else {
                              //   img = 0;
                              // }
                              setState(() {
                                cap_vis = true;
                              });
                            },
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/cam/reset.png'))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Visibility(
                          visible: cap_vis,
                          child: FloatingActionButton(
                            heroTag: 'capture',
                            // onPressed: () {
                            //   if (img == 0) {
                            //     img = 1;
                            //   } else {
                            //     img = 0;
                            //   }
                            //   setState(() {
                            //     cap_vis = false;
                            //   });
                            // },
                            onPressed: () async {
                              pictureFile = await controller.takePicture();
                              // importer.File imagefile =
                              //     importer.File(ImagePath);
                              // Uint8List imagebytes =
                              //     await imagefile.readAsBytes();
                              // ;

                              setState(() {
                                cap_vis = false;
                                ImagePath = pictureFile!.path;
                                // base64string = base64.encode(imageBytes);
                              });
                            },
                            backgroundColor: Colors.white,
                            child: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Visibility(
                            visible: !cap_vis,
                            child: FloatingActionButton(
                              heroTag: 'accept',
                              // onPressed: () {},
                              onPressed: () async {
                                // showDialog(
                                //     // The user CANNOT close this dialog  by pressing outsite it
                                //     barrierDismissible: false,
                                //     context: context,
                                //     builder: (_) {
                                //       return Dialog(
                                //         // The background color
                                //         backgroundColor: Colors.white,
                                //         child: Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               vertical: 20),
                                //           child: Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             children: const [
                                //               // The loading indicator
                                //               CircularProgressIndicator(),
                                //               SizedBox(
                                //                 height: 15,
                                //               ),
                                //               // Some text
                                //               Text('Loading...')
                                //             ],
                                //           ),
                                //         ),
                                //       );
                                //     });
                                var temp_path = await _localFile;
                                importer.File? imageFile =
                                    await testCompressAndGetFile(
                                        importer.File(ImagePath), temp_path);

                                var image = Img.decodeImage(
                                    await imageFile!.readAsBytes());
                                // var image = Img.decodeImage(
                                //     await importer.File(ImagePath)
                                //         .readAsBytes());
                                // var temp = File('temp.png')
                                //     .writeAsBytes(Img.encodePng(image!));
                                List<int> imageBytes = Img.encodePng(image!);
                                //  List<int> imageBytes =
                                //     await temp
                                //         .readAsBytes();
                                var b64 = base64.encode(imageBytes);
                                // log(b64);
                                importer.File(ImagePath).delete();
                                imageFile.delete();
                                log(b64);
                                Navigator.of(context).pop(b64);
                              },
                              backgroundColor: Colors.greenAccent,
                              foregroundColor: Colors.white,
                              child: Icon(Icons.check_sharp),
                            ))
                      ],
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
        // child: CameraPreview(controller),
      ),
      // bottomNavigationBar: SafeArea(
      //     child: Container(
      //   decoration: BoxDecoration(
      //       color: MainColor,
      //       border: Border(
      //           bottom: BorderSide(width: 1, color: MainColor),
      //           top: BorderSide(width: 1, color: MainColor))),
      //   height: 150,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           Visibility(
      //             visible: !cap_vis,
      //             child: FloatingActionButton(
      //               onPressed: () {
      //                 // if (img == 0) {
      //                 //   img = 1;
      //                 // } else {
      //                 //   img = 0;
      //                 // }
      //                 setState(() {
      //                   cap_vis = true;
      //                 });
      //               },
      //               backgroundColor: Colors.white,
      //               foregroundColor: Colors.black,
      //               child: Container(
      //                 width: 40,
      //                 decoration: BoxDecoration(
      //                     image: DecorationImage(
      //                         image: AssetImage('assets/cam/reset.png'))),
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             width: 80,
      //           ),
      //           Visibility(
      //             visible: cap_vis,
      //             child: FloatingActionButton(
      //               // onPressed: () {
      //               //   if (img == 0) {
      //               //     img = 1;
      //               //   } else {
      //               //     img = 0;
      //               //   }
      //               //   setState(() {
      //               //     cap_vis = false;
      //               //   });
      //               // },
      //               onPressed: () async {
      //                 pictureFile = await controller.takePicture();
      //                 setState(() {
      //                   cap_vis = false;
      //                   ImagePath = pictureFile!.path;
      //                 });
      //               },
      //               backgroundColor: Colors.white,
      //               child: Container(
      //                 width: 50,
      //                 decoration: BoxDecoration(
      //                     shape: BoxShape.circle,
      //                     color: Colors.white,
      //                     border: Border.all(color: Colors.black)),
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             width: 80,
      //           ),
      //           Visibility(
      //               visible: !cap_vis,
      //               child: FloatingActionButton(
      //                 onPressed: () {},
      //                 backgroundColor: Colors.greenAccent,
      //                 foregroundColor: Colors.white,
      //                 child: Icon(Icons.check_sharp),
      //               ))
      //         ],
      //       ),
      //     ],
      //   ),
      // )),
    );
  }
}

// class CameraPage extends StatefulWidget {
//   const CameraPage({required this.cameras, Key? key}) : super(key: key);

//   final List<CameraDescription> cameras;
//   @override
//   _CameraPageState createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   late CameraController controller;
//   XFile? pictureFile;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   controller = CameraController(
//   //     widget.cameras[1],
//   //     ResolutionPreset.max,
//   //   );
//   //   controller.initialize().then((_) {
//   //     if (!mounted) {
//   //       return;
//   //     }
//   //     setState(() {});
//   //   });
//   // }

//   // @override
//   // void dispose() {
//   //   controller.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return const SizedBox(
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: SizedBox(
//               height: 400,
//               width: 400,
//               child: CameraPreview(controller),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ElevatedButton(
//             onPressed: () async {
//               pictureFile = await controller.takePicture();
//               setState(() {});
//             },
//             child: const Text('Capture Image'),
//           ),
//         ),
//         if (pictureFile != null)
//           Image.network(
//             pictureFile!.path,
//             height: 200,
//           )
//         //Android/iOS
//         // Image.file(File(pictureFile!.path)))
//       ],
//     );
//   }
// }
