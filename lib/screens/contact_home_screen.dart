import 'package:assignment_project/models/contact_model.dart';
import 'package:assignment_project/screens/components/contact_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/contact_controller.dart';
import 'contact_screen.dart';

class ContactHomeScreen extends StatefulWidget {
  @override
  State<ContactHomeScreen> createState() => _ContactHomeScreenState();
}

class _ContactHomeScreenState extends State<ContactHomeScreen> {
  final ContactController _contactController = Get.put(ContactController());
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await _contactController.getAllContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Contacts",
              style: TextStyle(color: Colors.black),
            )),
        body: Obx(
          () => _contactController.contactList.isEmpty
              ? Center(
                  child: Text(
                    "There is no contact",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: _contactController.contactList.value.map((e) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ContactScreen(contactModel: e)));
                              },
                              child: ContactWidget(contactModel: e));
                        }).toList(),
                      )),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 20,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactScreen()));
          },
          backgroundColor: Colors.cyan,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ));
  }
}
