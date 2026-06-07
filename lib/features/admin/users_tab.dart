import 'package:batteryqk_web_app/features/admin/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';

import 'edit_dialog_box.dart';
import 'header_cell_widget.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  final TextEditingController _nameTEController =  TextEditingController();
  final TextEditingController _passwordTEController =  TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "User Management",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 30),
          Card(
            elevation: 1,
            color: Colors.white,
            child: Row(
              children: [
                HeaderCell(flex: 1, label: 'ID', color: Colors.black,fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'NAME', color: Colors.black, fontWeight: FontWeight.bold),
                HeaderCell(flex: 3, label: 'EMAIL', color: Colors.black,fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'JOIN DATE', color: Colors.black,fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'ACTIONS', color: Colors.black,fontWeight: FontWeight.bold),
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
                        fontWeight:FontWeight.bold ,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Md.Tayob ali',
                        color: Colors.grey.shade900,
                        fontWeight:FontWeight.normal ,
                      ),
                      HeaderCell(
                        flex: 3,
                        label: 'Mdtayobali@gmail.com',
                        color: Colors.grey.shade900,
                        fontWeight:FontWeight.normal ,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: '12/03/2025',
                        color: Colors.grey.shade900,
                        fontWeight:FontWeight.normal ,
                      ),
                      HeaderCell(
                        fontWeight:FontWeight.normal ,
                        flex: 2,
                        icons: [
                          Icons.edit_calendar,
                          Icons.delete_rounded,

                        ],
                        iconColors: [
                          Colors.yellow.shade300,
                          Colors.red,
                        ],
                        onIconPressed: (value) {
                          if (value == Icons.edit_calendar) {
                            showConfirmDialog(
                              isChange: true,
                              context: context,
                              title: 'Edit User',
                              onConfirmed: () {
                                print('User edited.');
                              },
                              confirmText: 'Save',
                              cancelText: 'Cancel',
                              isEdit: true,
                              initialValue1: _nameTEController.text,
                              initialValue2: _passwordTEController.text,
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
