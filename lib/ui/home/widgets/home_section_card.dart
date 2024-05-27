import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class HomeSectionCard extends StatelessWidget {
  const HomeSectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  final String title;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            //margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: ConstantColors.cff141718,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  height: 90,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
