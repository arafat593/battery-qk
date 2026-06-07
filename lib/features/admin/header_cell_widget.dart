import 'package:flutter/material.dart';

class HeaderCell extends StatelessWidget {
  final int flex;
   final String? label;
  final List<IconData>? icons;
  final List<Color>? iconColors;
  final Color? color;
  final void Function(IconData)? onIconPressed;
  final FontWeight fontWeight;

  const HeaderCell({
    super.key,
    required this.flex,
    this.label,
    this.icons,
    this.iconColors,
    this.color,
    this.onIconPressed,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final bool isSmallScreen = maxWidth < 350;
          final double iconSize = isSmallScreen ? 14 : 18;
          final double iconPadding = isSmallScreen ? 2 : 4;
          final double spacing = isSmallScreen ? 3 : 6;
          final double textSize = isSmallScreen ? 10 : 13;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (label != null) ...[
                    Flexible(
                      child: Text(
                        label!,
                        style: TextStyle(
                          fontWeight: fontWeight,
                          fontSize: textSize,
                          letterSpacing: 0.5,
                          color: color ?? Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: spacing),
                  ],
                  if (icons != null)
                    Row(
                      children: List.generate(icons!.length, (index) {
                        final iconData = icons![index];
                        final iconColor =
                            iconColors != null && index < iconColors!.length
                                ? iconColors![index]
                                : color ?? Colors.grey;

                        return Padding(//Md.Tayob ali
                          padding: EdgeInsets.symmetric(
                            horizontal: iconPadding / 2,
                          ),
                          child: GestureDetector(
                            onTap: () => onIconPressed?.call(iconData),
                            child: Padding(
                              padding: EdgeInsets.all(iconPadding),
                              child: Icon(
                                iconData,
                                size: iconSize,
                                color: iconColor,
                              ),
                            ),
                          ),
                        );
                      },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
