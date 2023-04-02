import 'dart:io';

import 'package:assignment_project/models/contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ContactService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<String> getImage(ImageSource imageSource) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: imageSource);
    final _firebaseStorage = FirebaseStorage.instance;
    if (image != null) {
      String fileName = image.path.split('/').last;
      var file = File(image.path);
      var snapshot =
          await _firebaseStorage.ref().child('images/$fileName').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      print("url is $downloadUrl");
      return downloadUrl.toString();
    } else {
      return "";
    }
  }

  Future<QuerySnapshot> getAllContactFromFirebase() async {
    QuerySnapshot data = await _db.collection("Contact").get();
    return data;
  }

  Future<void> addContactDataToFirebase(ContactModel contactModel) async {
    await _db
        .collection("Contact")
        .doc(contactModel.id.toString())
        .set(contactModel.toJson());
  }

  Future<void> updateContactFromFirebase(ContactModel contactModel) async {
    await _db
        .collection("Contact")
        .doc(contactModel.id)
        .update(contactModel.toJson());
  }

  Future<void> deleteContactFromFirebase(String documentId) async {
    await _db.collection("Contact").doc(documentId).delete();
  }
}
