import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unetpedia/widgets/buttons/generic_icon_button.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.title,
    required this.asset,
    required this.onPressed,
    this.onDownload,
    this.onWatch,
  });

  final String title;
  final String asset;
  final VoidCallback onPressed;
  final VoidCallback? onDownload;
  final VoidCallback? onWatch;

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
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      child: Container(
                        height: 70,
                        width: 70,
                        color: Colors.grey,
                        child: SvgPicture.asset(asset, fit: BoxFit.fill),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  GenericIconButton(
                    icon: Icons.download_rounded,
                    onPressed: () {},
                  ),
                  //const SizedBox(width: 12),
                  GenericIconButton(
                    icon: Icons.visibility_rounded,
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
