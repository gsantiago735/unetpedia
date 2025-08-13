import 'package:flutter/material.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';

class GenericInformationDialog extends StatelessWidget {
  const GenericInformationDialog({
    super.key,
    required this.title,
    this.description,
    this.oneButtonText = 'No',
    this.twoButtonText = "Sí",
    this.onOneButton,
    this.onTwoButton,
  });

  final String title;
  final String? description;

  final String oneButtonText;
  final String twoButtonText;
  final VoidCallback? onOneButton;
  final VoidCallback? onTwoButton;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  description ??
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet mattis vulputate enim nulla aliquet porttitor lacus luctus. Enim eu turpis egestas pretium aenean. ",
                  textAlign: TextAlign.center,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GenericButton(
                    text: oneButtonText,
                    color: Color(0xFFE53935),
                    onTap: onOneButton ?? () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: GenericButton(
                    text: twoButtonText,
                    onTap: onTwoButton,
                    color: Color(0xFF00378D),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
