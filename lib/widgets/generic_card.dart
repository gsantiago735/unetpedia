import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class GenericCard extends StatelessWidget {
  const GenericCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onPressed});

  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      //borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            //boxShadow: const [
            //  BoxShadow(
            //    color: Color(0x33201B39),
            //    offset: Offset(0, 4),
            //    blurRadius: 20.0,
            //    spreadRadius: 0.0,
            //  ),
            //]
          ),
          child: Row(
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Row(
                children: [
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ConstantColors.cff141718,
                  ),
                  SizedBox(width: 12),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
