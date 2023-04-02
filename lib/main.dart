import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'screens/contact_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ContactHomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var image;
  String imageUrl = '';
  bool isHiveData = false;
  TextEditingController _nameCTRL = TextEditingController();
  TextEditingController _fatherCTRL = TextEditingController();
  setDataToFirebase() async {
    final _firebaseStorage = FirebaseStorage.instance;
    if (image != null) {
      //Upload to Firebase
      var file = File(image.path);
      var snapshot = await _firebaseStorage
          .ref()
          .child('images/imageName.jpg')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      print("url is $downloadUrl");
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
    if (imageUrl.isNotEmpty) {
      await FirebaseFirestore.instance.collection("demo").doc().set({
        "name": _nameCTRL.text,
        "father'sName": _fatherCTRL.text,
        "imageUrl": imageUrl
      });
    }
    setState(() {});
  }

  // setDataFromHiveToFirebase() async {
  //   var box = await Hive.openBox("info");
  //   var data = box.get("user");
  //   final _firebaseStorage = FirebaseStorage.instance;
  //   final tempDir = await getTemporaryDirectory();
  //   File file = await File('${tempDir.path}/image.png').create();
  //   file.writeAsBytesSync(data['url']);
  //   print("File is ${file.path}");
  //   if (file.path != "") {
  //     var snapshot = await _firebaseStorage
  //         .ref()
  //         .child('images/imageName.jpg')
  //         .putFile(file);
  //     var downloadUrl = await snapshot.ref.getDownloadURL();
  //     print("url is $downloadUrl");
  //     setState(() {
  //       imageUrl = downloadUrl;
  //     });
  //   } else {
  //     print('No Image Path Received');
  //   }
  //   if (imageUrl.isNotEmpty) {
  //     await FirebaseFirestore.instance.collection("demo").doc().set({
  //       "name": data['name'],
  //       "father'sName": data['fatherName'],
  //       "imageUrl": imageUrl
  //     });
  //   }
  //   await box.clear();
  //   isHiveData = false;
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        'https://googleflutter.com/sample_image.jpg'),
                    fit: BoxFit.fill),
              ),
            ))
        // TextButton(
        //   onPressed: () async {
        //     String telephoneNumber = '+2347012345678';
        //     String telephoneUrl = "tel:$telephoneNumber";
        //     if (await canLaunchUrl(Uri.parse(telephoneUrl))) {
        //       await launchUrl(Uri.parse(telephoneUrl));
        //     } else {
        //       throw "Error occured trying to call that number.";
        //     }
        //   },
        //   child: Text("dsd"),
        // )),
        );
  }

  getImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.camera);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Image taken from camera")));
  }
}
