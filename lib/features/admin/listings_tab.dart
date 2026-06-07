import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';
import '../../common/widgets/custom_elevated_Icon_Button.dart';
import '../../common/widgets/dialog_BoxFor_Admin_Listing.dart';
import 'add_category_dialog.dart';
import 'edit_dialog_box.dart';
import 'header_cell_widget.dart';

class ListingTab extends StatefulWidget {
  const ListingTab({super.key});

  @override
  State<ListingTab> createState() => _ListingTabState();
}

class _ListingTabState extends State<ListingTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _downTownController = TextEditingController();
  final TextEditingController _ageGroupController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _discreptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Listing Management",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  CustomElevatedIconButton(
                    color: AppColor.blueColor,
                    buttonText: "Add Category",
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const AddCategoryDialog(),
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  CustomElevatedIconButton(
                    color: AppColor.blueColor,
                    icon: Icon(Icons.add),
                    buttonText: "New Listing",
                    onPressed: () {
                      showEditDialog(
                        context: context,
                        title: 'Edit User',
                        onConfirmed: () {
                          print('User edited.');
                        },
                        confirmText: 'Add Listing',
                        cancelText: 'Cancel',
                        isEdit: true,
                        initialValue1: _nameController.text,
                        initialValue3: _downTownController.text,
                        initialValue4: _ageGroupController.text,
                        initialValue5: _priceController.text,
                        initialValue6: _imageUrlController.text,
                        initialValue7: _discreptionController.text,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Card(
            elevation: 1,
            color: Colors.white,
            child: Row(
              children: [
                HeaderCell(
                  flex: 1,
                  label: 'ID',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 2,
                  label: 'NAME',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 3,
                  label: 'CATEGORY',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 2,
                  label: 'LOCATION',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 2,
                  label: 'AGE GROUP',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 2,
                  label: 'ACTION',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Row(
                    children: [
                      HeaderCell(
                        flex: 1,
                        label: index.toString(),
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Elite Swimming Academy',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 3,
                        label: 'Swimming',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Downtown',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Age Group',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        fontWeight: FontWeight.normal,
                        flex: 2,
                        icons: [
                          Icons.visibility,
                          Icons.edit,
                          Icons.delete_rounded,
                        ],
                        iconColors: [
                          Colors.blue,
                          Colors.yellow.shade300,
                          Colors.red,
                        ],

                        onIconPressed: (value) {
                          if (value == Icons.edit) {
                            showEditDialog(
                              context: context,
                              title: 'Edit User',
                              onConfirmed: () {
                                print('User edited.');
                              },
                              confirmText: 'Save',
                              cancelText: 'Cancel',
                              isEdit: true,
                              initialValue1: _nameController.text,
                              initialValue3: _downTownController.text,
                              initialValue4: _ageGroupController.text,
                              initialValue5: _priceController.text,
                              initialValue6: _imageUrlController.text,
                              initialValue7: _discreptionController.text,
                            );
                          } else if (value == Icons.delete_rounded) {
                            showEditDialog(
                              context: context,
                              title: 'Delete User',
                              onConfirmed: () {
                                print('User deleted.');
                              },
                              confirmText: 'Delete',
                              cancelText: 'Cancel',
                            );
                          } else if (value == Icons.visibility) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => const DialogBoxForAdminListing(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
