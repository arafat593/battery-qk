import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart'
    show AppText;

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.height,
    this.width,
    this.alignment,
    this.child,
    this.decoration,
    this.onTap,
    this.padding,
    this.title,
    this.isLoading = false,
    this.loaderColor,
    this.margin,
    this.backgroundColor,
    this.loadingSize,
    this.titleColor,
    this.border,
    this.borderColor,
    this.fontSize,
    this.borderRadius,
    this.fontWeight,
    this.leading,
    this.trailing,
    this.leadingIconImage,
    this.trailingIconImage,
  });

  final double? loadingSize;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Decoration? decoration;
  final Widget? child;
  final String? title;
  final void Function()? onTap;
  final bool isLoading;
  final Color? titleColor;
  final Color? loaderColor;
  final Color? backgroundColor;
  final BoxBorder? border;
  final Color? borderColor;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;
  final FontWeight? fontWeight;
  final IconData? leading;
  final String? leadingIconImage;
  final IconData? trailing;
  final String? trailingIconImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: Durations.long1,
        curve: Curves.ease,
        width: width,
        height: height,
        alignment: alignment ?? Alignment.center,
        margin: margin,
        padding:
            padding ??
            EdgeInsets.symmetric(vertical: AppSize.size.height * 0.013),
        decoration:
            decoration ??
            BoxDecoration(
              color: backgroundColor ?? AppColors.instance.buttonColor,
              border:
                  border ??
                  Border.all(
                    color: borderColor ?? AppColors.instance.buttonColor,
                  ),
              borderRadius:
                  borderRadius ??
                  BorderRadius.circular(
                    AppSize.width(value: AppSize.width(value: 8.0)),
                  ),
            ),
        child: isLoading
            ? SizedBox(
                width: loadingSize ?? AppSize.size.height * 0.04,
                height: loadingSize ?? AppSize.size.height * 0.04,
                child: CircularProgressIndicator(
                  color: loaderColor ?? AppColors.instance.white50,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child ??
                      Icon(
                        leading,
                        weight: 13,
                        color: AppColors.instance.white50,
                      ),
                  if (leadingIconImage != null)
                    AppImage(
                      path: leadingIconImage,
                      width: 13,
                      color: Colors.white,
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.size.width * 0.02,
                    ),
                    child: AppText(
                      text: title ?? "",
                      color: titleColor ?? AppColors.instance.white50,
                      fontWeight: fontWeight ?? FontWeight.w500,
                      fontSize: fontSize ?? 18,
                    ),
                  ),
                  Icon(trailing, weight: 13, color: AppColors.instance.white50),
                  if (trailingIconImage != null)
                    AppImage(
                      path: trailingIconImage,
                      width: 13,
                      color: Colors.white,
                    ),
                ],
              ),
      ),
    );
  }
}
