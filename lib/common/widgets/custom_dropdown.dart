import 'package:batteryqk_web_app/util/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String listType;
  final double? fontSize;
  final List<String> itemList;

  const CustomDropdownButton({
    super.key,
    required this.itemList,
    required this.listType,
    this.fontSize = 16,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? selectedItem;
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;
  bool iisFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
        iisFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Focus(
        focusNode: _focusNode,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            value: selectedItem,
            hint: Text(
              widget.listType,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).hintColor,
              ),
            ),
            items:
                widget.itemList
                    .map(
                      (String item) => DropdownMenuItem(
                        enabled: true,
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                selectedItem = value;
              });
            },
            iconStyleData: IconStyleData(
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              iconSize: 20,
              iconEnabledColor: iisFocused ? AppColor.blueColor : Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              isOverButton: false,
              maxHeight: 300,
              useSafeArea: true,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              elevation: 3,
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(AppColor.blueColor),
              ),
            ),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: double.infinity,
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
