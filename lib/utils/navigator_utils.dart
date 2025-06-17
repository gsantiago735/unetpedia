import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/utils/local_storage.dart';

class NavigatorUtils {
  /// Resetea los cubits generales, cierra sesión y redirecciona al Login
  static Future<void> resetSession(
    BuildContext context, {
    bool needsLogOut = true,
  }) async {
    final generalCubit = context.read<GeneralCubit>();

    if (needsLogOut) {
      await generalCubit.logOut();
    }

    generalCubit.clean();

    await LocalStorage.deleteSession().then((_) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
    });
  }
}
