import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/message_screen/widget/message_heading_title.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';
import '../../utils/gap.dart';


class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  int selectedFilter = 0;

  final List<String> filters = ["All Messages", "Unread", "Verified Only"];

  final List<Map<String, dynamic>> chats = [
    {
      "name": "Luxe Interiors Ltd",
      "message": "Your custom sofa design is re...",
      "time": "10:42 AM",
      "isVerified": true,
      "hasUnread": true,
      "image": "https://i.pravatar.cc/150?u=1",
    },
    {
      "name": "Green Grove Organics",
      "message": "Thank you for your order. Your deliv...",
      "time": "YESTERDAY",
      "isVerified": false,
      "hasUnread": false,
      "image": "https://i.pravatar.cc/150?u=2",
    },
    {
      "name": "The Daily Grind Cafe",
      "message": "We've launched our new seasonal ...",
      "time": "WEDNESDAY",
      "isVerified": true,
      "hasUnread": false,
      "image": "https://i.pravatar.cc/150?u=3",
    },
    {
      "name": "Swift Clean Pro",
      "message": "Confirming your booking for ...",
      "time": "OCT 24",
      "isVerified": false,
      "hasUnread": true,
      "image": "https://i.pravatar.cc/150?u=4",
    },
    {
      "name": "Zenith Luxury Goods",
      "message": "The item you were inquiring about is...",
      "time": "OCT 22",
      "isVerified": false,
      "hasUnread": false,
      "image": "https://i.pravatar.cc/150?u=5",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Messages",showBackButton: false,),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: AppSize.size.width * 0.04),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedFilter == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilter = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1E2126)
                            : const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        text: filters[index],
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),

            const Gap(height: 20),

            // --- Message List ---
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                ),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return MessageHeadingTitle(
                    chat: chat,
                    onTap: () {
                      AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.messagesDetailsScreen,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
