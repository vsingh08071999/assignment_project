import 'dart:io';

import 'package:assignment_project/bloc/internet_bloc.dart';
import 'package:assignment_project/bloc/internet_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox("info");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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

  setDataToHive() async {
    var box = await Hive.openBox("info");
    var imageData = await File(image.path).readAsBytes();
    print("box length ${box.length}  ${imageData.length}");
    await box.put("user", {
      "name": _nameCTRL.text,
      "fatherName": _fatherCTRL.text,
      "url": imageData
    });
    isHiveData = true;
    print("box length ${box.length}   ${box.get("user")}");
  }

  setDataFromHiveToFirebase() async {
    var box = await Hive.openBox("info");
    var data = box.get("user");
    final _firebaseStorage = FirebaseStorage.instance;
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(data['url']);
    print("File is ${file.path}");
    if (file.path != "") {
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
        "name": data['name'],
        "father'sName": data['fatherName'],
        "imageUrl": imageUrl
      });
    }
    await box.clear();
    isHiveData = false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Center(
            child: BlocConsumer<InternetBloc, InternetState>(
                listener: (context, state) {
          if (state is InternetConnectedState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Your internet is connected")));
          } else if (state is InternetLostState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Your internet is lost")));
          }
        }, builder: ((context, state) {
          if (state is InternetConnectedState && isHiveData) {
            print("Hive has data");
            setDataFromHiveToFirebase();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(hintText: "Enter your name"),
                controller: _nameCTRL,
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: "Enter your father's name"),
                controller: _fatherCTRL,
              ),
              RaisedButton(
                onPressed: () {
                  getImage();
                },
                child: Text("Image", style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
              RaisedButton(
                onPressed: () {
                  if (state is InternetConnectedState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                            "Your internet is connected and data will store to the firebase")));

                    setDataToFirebase();
                  } else if (state is InternetLostState) {
                    setDataToHive();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                            "Your internet is lost and data will store to the hive")));
                  }
                  _fatherCTRL.clear();
                  _nameCTRL.clear();
                },
                child: Text("Submit", style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              )
            ],
          );
        }))),
      ),
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
