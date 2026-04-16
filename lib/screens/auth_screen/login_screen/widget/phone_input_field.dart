import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/inputs/app_input_widget.dart';
import '../../../../widgets/texts/app_text.dart';

class PhoneInputField extends StatefulWidget {
  final String label;
  final String defaultCountryCode;
  final String defaultFlag;
  final Color? containerColor;
  final Color? textColor;

  const PhoneInputField({
    super.key,
    this.label = "PHONE NUMBER",
    this.defaultCountryCode = "234",
    this.defaultFlag = "🇳🇬",
    this.containerColor,
    this.textColor,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late String _countryCode;
  late String _flagEmoji;

  @override
  void initState() {
    super.initState();
    _countryCode = widget.defaultCountryCode;
    _flagEmoji = widget.defaultFlag;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: AppText(
            text: widget.label,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: widget.containerColor ??
                AppColors.instance.containerColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    countryListTheme: CountryListThemeData(
                      textStyle: TextStyle(
                        color: AppColors.instance.black500,
                        fontSize: 16,
                      ),
                      searchTextStyle: TextStyle(
                        color: AppColors.instance.black500,
                      ),
                    ),
                    onSelect: (Country country) {
                      setState(() {
                        _countryCode = country.phoneCode;
                        _flagEmoji = country.flagEmoji;
                      });
                    },
                  );
                },
                child: Row(
                  children: [
                    AppText(text: _flagEmoji, fontSize: 24),
                    Gap(width: 8),
                    AppText(
                      text: "+$_countryCode",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),

              Container(
                height: 24,
                width: 1,
                color: Colors.grey[400],
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),

              Expanded(
                child: AppInputWidget(
                  fillColor: widget.containerColor ??
                      AppColors.instance.containerColor,
                  textColor:
                  widget.textColor ?? AppColors.instance.black500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}