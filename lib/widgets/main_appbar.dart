import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constants.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.isBoldTitle = false,
    this.needsGoback = true,
    this.titleColor = Colors.white,
    this.leadingIconColor = Colors.white,
    this.backgroundColor = ConstantColors.cff141718,
    this.onBack,
    this.actions,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  final bool centerTitle;
  final String title;
  final Color titleColor;
  final bool isBoldTitle;
  final bool needsGoback;
  final Color leadingIconColor;
  final Color backgroundColor;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  final Size preferredSize;

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: widget.centerTitle,
      backgroundColor: widget.backgroundColor,
      surfaceTintColor: widget.backgroundColor,
      actions: widget.actions,
      leading: (widget.needsGoback)
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: widget.leadingIconColor,
              ),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.transparent),
              ),
              onPressed: (widget.onBack != null)
                  ? widget.onBack
                  : () => Navigator.maybePop(context),
            )
          : null,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: widget.isBoldTitle ? 28 : 22,
          color: widget.titleColor,
          fontWeight: widget.isBoldTitle ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}
