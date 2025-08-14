import 'package:flutter/material.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/home/views/views.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/utils/navigator_utils.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/generic_network_image.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  static const String routeName = 'settings_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "Ajustes", isWhite: true),
      body: BlocListener<GeneralCubit, GeneralState>(
        listenWhen: (p, c) => (p.logOutStatus != c.logOutStatus),
        listener: (context, state) {
          switch (state.logOutStatus) {
            case WidgetStatus.loading:
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (context) => PopScope(
                  canPop: false,
                  child: Center(child: LoadingIndicator()),
                ),
              );
              break;

            case WidgetStatus.error:
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (context) => GenericStatusDialog(
                  description: state.exception?.details,
                  isErrorDialog: true,
                ),
              );
              break;

            default:
              break;
          }
        },
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _UserInfoComponent(),
            ),
            _ListTile(
              title: "Editar Perfil",
              icon: Icons.person_rounded,
              onPressed: () =>
                  Navigator.pushNamed(context, EditProfileView.routeName),
            ),
            const SizedBox(height: 15),
            _ListTile(
              title: "Mis Documentos",
              icon: Icons.description_rounded,
              onPressed: () {
                context.read<GeneralCubit>().selectDepartment(null);
                context.read<GeneralCubit>().selectSubject(null);

                Navigator.pushNamed(context, MyDocumentsView.routeName);
              },
            ),
            const SizedBox(height: 15),
            _ListTile(
              title: "Cambiar Contraseña",
              icon: Icons.key_rounded,
              onPressed: () =>
                  Navigator.pushNamed(context, UpdatePasswordView.routeName),
            ),
            const SizedBox(height: 15),
            _ListTile(
              title: "Cerrar Sesión",
              icon: Icons.logout_rounded,
              onPressed: () => NavigatorUtils.resetSession(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInfoComponent extends StatelessWidget {
  const _UserInfoComponent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(thickness: 1, color: Color(0xFFF1F5F9), height: 30),
        BlocBuilder<GeneralCubit, GeneralState>(
          buildWhen: (p, c) => (p.user != c.user),
          builder: (context, state) {
            return Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFFD9D9D9),
                    ),
                  ),
                  child: GenericNetworkImage(
                    url: state.user?.photoUrl,
                    borderRadius: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user?.fullName ?? "...",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: ConstantColors.cff141718,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        state.userCareer?.name ?? "...",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ConstantColors.cff141718,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Tipo de cuenta: ${state.user?.roleParsed}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const Divider(thickness: 1, color: Color(0xFFF1F5F9), height: 30),
      ],
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.title, required this.icon, this.onPressed});

  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      dense: false,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: ConstantColors.cff141718,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(width: 2, color: const Color(0xFFD9D9D9)),
        ),
        child: Icon(icon, color: ConstantColors.cff141718),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: ConstantColors.cff141718,
      ),
    );
  }
}
