import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/screens/message_details_screen/widget/message_bubble.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../widgets/texts/app_text.dart';
import '../../utils/gap.dart';

class MessagesDetailsScreen extends StatelessWidget {
  const MessagesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=clean',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.red,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            Gap(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "LuxeClean Solutions",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                AppText(
                  text: "ONLINE",
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- Chat Messages Area ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.instance.hintText.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText(
                      text: "TODAY",
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.instance.hintText,
                    ),
                  ),
                ),
                const Gap(height: 20),

                // Receiver Message
                MessageBubble(
                  message:
                      "Hello! Thank you for reaching out. How can we help you today?",
                  time: "09:12 AM",
                  isMe: false,
                ),

                // Sender Message
                MessageBubble(
                  message:
                      "I'd like to get a quote for a deep cleaning of a 3-bedroom apartment in Ikeja.",
                  time: "Delivered",
                  isMe: true,
                  showStatus: true,
                ),

                MessageBubble(
                  message:
                      "Hello! Thank you for reaching out. How can we help you today?",
                  time: "09:12 AM",
                  isMe: false,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.instance.hintText.withAlpha(70),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black54,
                        weight: 16,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
                const Gap(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.instance.hintText.withAlpha(70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppInputWidget(
                            fillColor: AppColors.instance.transparent,
                            textColor: AppColors.instance.black500,
                            border: InputBorder.none,
                            maxLines: 5,
                          ),
                        ),
                        Gap(width: 4),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53935), // Red Send Button
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(height: 20),
        ],
      ),
    );
  }
}
