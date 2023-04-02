import 'package:assignment_project/controllers/contact_controller.dart';
import 'package:assignment_project/models/contact_model.dart';
import 'package:assignment_project/screens/components/profile_widget.dart';
import 'package:assignment_project/screens/components/text_field.dart';
import 'package:assignment_project/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/loading_widget.dart';
import 'components/showMessage.dart';

class ContactScreen extends StatefulWidget {
  ContactModel? contactModel;
  ContactScreen({this.contactModel});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  ContactService contactService = ContactService();
  final ContactController _contactController = Get.put(ContactController());
  bool _isLoading = false;
  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() {
    if (widget.contactModel != null) {
      _contactController.contactModel.value = widget.contactModel!;
      _name.text = widget.contactModel!.name;
      _number.text = widget.contactModel!.number;
    } else {
      _contactController.contactModel.value =
          ContactModel(name: "", number: "", profile: "", id: "");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                _contactController.contactModel.value =
                    ContactModel(name: "", number: "", profile: "", id: "");
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          actions: [
            MaterialButton(
                child: Text(
                  widget.contactModel == null ? "SAVE" : "EDIT",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  dataSaveOrEdit();
                },
                color: Colors.cyan),
          ],
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        _isLoading
                            ? LoadingWidget(
                                height: 180,
                                width: 180,
                              )
                            : ProfileWidget(
                                height: 180,
                                profileUrl: _contactController
                                    .contactModel.value.profile,
                                width: 180),
                        Positioned(
                          bottom: 5,
                          right: 13,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13.0),
                                  ),
                                  context: context,
                                  builder: ((context) => imageOptionWidget()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              child: Icon(Icons.mode_edit_outline_outlined,
                                  color: Colors.black),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      50,
                                    ),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 4),
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 3,
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          TextFieldWidget(
                              controller: _name,
                              hintText: "Name",
                              labelText: "Name",
                              textInputType: TextInputType.name,
                              prefixIcon: Icons.person,
                              maxLength: null,
                              iconButton: null),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            controller: _number,
                            hintText: "Mobile Number",
                            labelText: "Mobile Number",
                            prefixIcon: Icons.mobile_friendly,
                            textInputType: TextInputType.number,
                            maxLength: 10,
                            iconButton: IconButton(
                                onPressed: () async {
                                  if (_number.text.isNotEmpty) {
                                    String telephoneNumber = _number.text;
                                    String telephoneUrl =
                                        "tel:$telephoneNumber";
                                    if (await canLaunchUrl(
                                        Uri.parse(telephoneUrl))) {
                                      await launchUrl(Uri.parse(telephoneUrl));
                                    } else {
                                      throw "Error occured trying to call that number.";
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              "Please enter mobile number",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )));
                                  }
                                },
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.cyan,
                                )),
                          )
                        ],
                      )
                    ],
                  ))),
        ),
      ),
    );
  }

  Widget imageOptionWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: BoxDecoration(
          color: Colors.cyan,
          border: Border.all(color: Colors.cyan),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  _isLoading = true;
                });
                await _contactController
                    .getImageFromController(ImageSource.gallery);
                setState(() {
                  _isLoading = false;
                });
              },
              icon: const Icon(
                Icons.image,
                color: Colors.white,
                size: 50,
              )),
          const VerticalDivider(
            color: Colors.white,
            thickness: 2,
          ),
          IconButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  _isLoading = true;
                });
                await _contactController
                    .getImageFromController(ImageSource.camera);
                setState(() {
                  _isLoading = false;
                });
              },
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 50,
              ))
        ],
      ),
    );
  }

  Future dataSaveOrEdit() async {
    if (_name.text.toString().trim().isNotEmpty &&
        _number.text.toString().trim().isNotEmpty) {
      _contactController.contactModel.value.name = _name.text;
      _contactController.contactModel.value.number = _number.text;
      if (widget.contactModel == null) {
        await _contactController.addContactDataToFirebaseController();
        Message().getSuccessfulMessage("Contact added successfully", context);
      } else {
        await _contactController
            .updateContact(_contactController.contactModel.value);
        Message().getSuccessfulMessage("Updated successfully", context);
      }
    } else {
      Message().getErrorMessage("Please fill name or number", context);
    }
  }
}
