import 'package:flutter/material.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';

class GenericStatusDialog extends StatelessWidget {
  const GenericStatusDialog({
    super.key,
    this.title,
    this.description,
    this.buttonText = 'Continuar',
    this.isErrorDialog = false,
    this.onTap,
  });

  final String? title;
  final String? description;
  final String buttonText;
  final bool isErrorDialog;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // insetPadding: EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.width * 0.10,
      //     vertical: MediaQuery.of(context).size.height * 0.20),
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  (isErrorDialog) ? Icons.cancel : Icons.check_circle_rounded,
                  color: (isErrorDialog)
                      ? const Color(0xFFE53935)
                      : const Color(0xFF00C566),
                  size: 100,
                ),
              ),
              Column(children: [
                Text(
                  (isErrorDialog)
                      ? (title ?? '¡Opps! algo ha salido mal')
                      : (title ?? "Operación Exitosa."),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  (isErrorDialog)
                      ? (description ?? '¡Opps! algo ha salido mal')
                      : (description ?? "Operación Exitosa."),
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
                const SizedBox(height: 15),
              ]),
              GenericButton(
                onTap: onTap ?? () => Navigator.pop(context),
                text: buttonText,
              )
            ]),
      ),
    );
  }
}
