import 'package:assignment_project/models/contact_model.dart';
import 'package:assignment_project/screens/components/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/contact_controller.dart';
import 'showMessage.dart';

class ContactWidget extends StatefulWidget {
  ContactModel contactModel;
  ContactWidget({required this.contactModel});

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  final ContactController _contactController = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListTile(
        trailing: InkWell(
            onTap: () async {
              await _contactController.deleteContact(widget.contactModel.id);
              Message().getSuccessfulMessage("Deleted successfully", context);
            },
            child: const Icon(
              Icons.delete_forever,
              size: 25,
              color: Colors.red,
            )),
        leading: ProfileWidget(
            height: 50, profileUrl: widget.contactModel.profile, width: 50),
        title: Row(
          children: [
            const SizedBox(
              height: 40,
              child: VerticalDivider(
                width: 0,
                thickness: 0.5,
                color: Colors.cyan,
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(widget.contactModel.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(widget.contactModel.number,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
