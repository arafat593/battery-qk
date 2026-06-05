import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/screens/base_screen/about_us_screen/provider/about_us_screen_provider.dart';
import 'package:olabisiolai_flutter_app/screens/base_screen/widgets/base_data_widget.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aboutUsScreenProvider);

    return Scaffold(
      appBar: CustomAppBar(title: "About Us"),
      body: SafeArea(
        child: state.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: AppText(text: "No Content Available"));
            }
            return BaseDataWidget(data: data);
          },
          error: (error, stackTrace) =>
              const Center(child: AppText(text: "Something went wrong!")),
          loading: () => Skeletonizer(
            child: BaseDataWidget(
              data: List.generate(
                20,
                (index) => "<p>Loading about us details from server...</p>",
              ).join(""),
            ),
          ),
        ),
      ),
    );
  }
}
