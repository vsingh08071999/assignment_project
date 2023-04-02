import 'package:assignment_project/models/contact_model.dart';
import 'package:assignment_project/services/contact_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;

class ContactController extends GetxController {
  final ContactService _contactService = ContactService();
  Rx<ContactModel> contactModel =
      ContactModel(name: "", number: "", profile: "", id: "").obs;
  RxList<ContactModel> contactList = <ContactModel>[].obs;
  Future getImageFromController(ImageSource imageSource) async {
    String url = await _contactService.getImage(imageSource);
    if (url.isNotEmpty) {
      contactModel.value.profile = url;
      contactModel.refresh();
    }
  }

  Future<void> addContactDataToFirebaseController() async {
    var rnd = math.Random();
    var id = rnd.nextDouble() * 1000000;
    while (id < 100000) {
      id *= 10;
    }
    contactModel.value.id = id.floor().toString();
    contactList.add(contactModel.value);
    await _contactService.addContactDataToFirebase(contactModel.value);
    contactList.refresh();
  }

  Future<void> getAllContact() async {
    QuerySnapshot data = await _contactService.getAllContactFromFirebase();
    if (data.docs.isNotEmpty) {
      data.docs.forEach((element) {
        Map doc = element.data() as Map;
        contactList.add(ContactModel(
            name: doc['name'],
            number: doc['number'],
            profile: doc['profile'],
            id: doc['id']));
      });
    }
    contactList.refresh();
  }

  Future<void> updateContact(ContactModel contactModel) async {
    int index = contactList.value
        .indexWhere((element) => element.id == contactModel.id);
    contactList.value.removeAt(index);
    contactList.insert(index, contactModel);
    await _contactService.updateContactFromFirebase(contactModel);
    contactList.refresh();
  }

  Future<void> deleteContact(String documentId) async {
    contactList.value.removeWhere((element) => element.id == documentId);
    await _contactService.deleteContactFromFirebase(documentId);
    contactList.refresh();
  }
}
