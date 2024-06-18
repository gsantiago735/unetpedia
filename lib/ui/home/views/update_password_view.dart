import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/utils/local_storage.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/ui/authentication/cubit/cubit.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';

class UpdatePasswordView extends StatelessWidget {
  const UpdatePasswordView({super.key});
  static const String routeName = 'update_password_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MainAppBar(
          title: "Cambiar Contraseña",
          isWhite: true,
        ),
        body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
            listenWhen: (p, c) => (p.status != c.status),
            listener: (context, state) {
              switch (state.status) {
                case WidgetStatus.error:
                  showDialog<void>(
                    context: context,
                    builder: (context) => GenericStatusDialog(
                      description: state.errorText,
                      isErrorDialog: true,
                    ),
                  );
                  break;
                case WidgetStatus.success:

                  // Comprobando si hay data en cache
                  if ((LocalStorage.getEmail() ?? "").isNotEmpty) {
                    // Actualizando data en cache
                    LocalStorage.setCredentials(
                      email: LocalStorage.getEmail(),
                      password: state.password,
                    );
                  }

                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => GenericStatusDialog(
                      title: "Operación exitosa.",
                      description: "Contraseña actualizada.",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  );
                  break;
                default:
                  break;
              }
            },
            buildWhen: (p, c) => (p.status != c.status),
            builder: (context, state) {
              return Stack(
                children: [
                  const _View(),
                  if (state.status == WidgetStatus.loading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        child: const Center(child: LoadingIndicator()),
                      ),
                    ),
                ],
              );
            }),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> {
  final _formKey = GlobalKey<FormState>();

  late AuthenticationCubit cubit;
  late TextEditingController _currentPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _cPasswordController;

  @override
  void initState() {
    cubit = context.read<AuthenticationCubit>();
    _currentPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _cPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    buildWhen: (p, c) => (p.showPassword != c.showPassword),
                    builder: (context, state) {
                      return FormInput(
                        labelText: "Contraseña Actual",
                        hintText: "Ingresar contraseña actual",
                        controller: _currentPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: state.showPassword,
                        validator: (value) =>
                            Validators.loginPasswordValidation(value),
                        suffixIcon: IconButton(
                          onPressed: () => cubit.changePasswordVisibility(),
                          icon: Icon(
                            (state.showPassword)
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                            color: const Color(0xFF9CA4AB),
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 24),
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    buildWhen: (p, c) => (p.showPassword != c.showPassword),
                    builder: (context, state) {
                      return FormInput(
                        labelText: "Nueva Contraseña",
                        hintText: "Ingresar nueva contraseña",
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: state.showPassword,
                        validator: (value) =>
                            Validators.registerPasswordValidation(
                                value,
                                _passwordController.text,
                                _cPasswordController.text),
                        suffixIcon: IconButton(
                          onPressed: () => cubit.changePasswordVisibility(),
                          icon: Icon(
                            (state.showPassword)
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                            color: const Color(0xFF9CA4AB),
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 24),
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    buildWhen: (p, c) => (p.showPassword != c.showPassword),
                    builder: (context, state) {
                      return FormInput(
                        labelText: "Confirmar Contraseña",
                        hintText: "Ingresar contraseña",
                        controller: _cPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: state.showPassword,
                        validator: (value) =>
                            Validators.registerPasswordValidation(
                                value,
                                _passwordController.text,
                                _cPasswordController.text),
                        suffixIcon: IconButton(
                          onPressed: () => cubit.changePasswordVisibility(),
                          icon: Icon(
                            (state.showPassword)
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                            color: const Color(0xFF9CA4AB),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: GenericButton(
              text: "Confirmar",
              onTap: () {
                FocusScope.of(context).unfocus();

                if (_formKey.currentState!.validate()) {
                  cubit.changePassword(
                    currentPassword: _currentPasswordController.text,
                    newPassword: _passwordController.text,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
