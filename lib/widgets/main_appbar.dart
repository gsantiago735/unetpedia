import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constants.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.isBoldTitle = false,
    this.needsGoback = true,
    this.isWhite = false,
    this.onBack,
    this.actions,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  final bool centerTitle;
  final String title;
  final bool isBoldTitle;
  final bool needsGoback;
  final bool isWhite;
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
      backgroundColor: (widget.isWhite)
          ? Colors.white
          : ConstantColors.cff141718,
      surfaceTintColor: (widget.isWhite)
          ? Colors.white
          : ConstantColors.cff141718,
      actions: widget.actions,
      leading: (widget.needsGoback)
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: (widget.isWhite) ? Colors.black : Colors.white,
              ),
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
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
          color: (widget.isWhite) ? Colors.black : Colors.white,
          fontWeight: widget.isBoldTitle ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }
}
