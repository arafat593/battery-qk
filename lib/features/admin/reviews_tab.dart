import 'package:flutter/material.dart';

import 'header_cell_widget.dart';

class ReviewsTab extends StatefulWidget {
  const ReviewsTab({super.key});

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Review Management",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Card(
            elevation: 1,
            color: Colors.white,
            child: Row(
              children: [
                HeaderCell(flex: 1, label: 'ID', color: Colors.black, fontWeight: FontWeight.bold,),
                HeaderCell(flex: 2, label: 'User', color: Colors.black, fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'Listing', fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'Comment', fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'Date', fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'Status', fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'Actions', fontWeight: FontWeight.bold),
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
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Md.Tayob ali',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Elite Swimming Academy',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Excellent facilities and coaches!',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: '5/13/2025',
                        color: Colors.grey.shade900,
                        fontWeight:FontWeight.normal ,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Pending',
                        color: Colors.grey.shade900,
                        fontWeight:FontWeight.normal ,
                      ),
                      HeaderCell(
                        flex: 2,
                        icons: [Icons.add_task, Icons.cancel_outlined],
                        iconColors: [Colors.green, Colors.red],
                        fontWeight:FontWeight.normal ,
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
