import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/ui/authentication/cubit/cubit.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});
  static const String routeName = 'forgot_pasword_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MainAppBar(title: "Recuperar Contraseña", isWhite: true),
        body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listenWhen: (p, c) => (p.genericStatus != c.genericStatus),
          listener: (context, state) {
            switch (state.genericStatus) {
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
                Navigator.pop(context);
                showDialog<void>(
                  context: context,
                  builder: (context) => GenericStatusDialog(
                    description: state.exception?.details,
                    isErrorDialog: true,
                  ),
                );
                break;
              case WidgetStatus.success:
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => GenericStatusDialog(
                    title: "Operación exitosa.",
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
          buildWhen: (p, c) => (p.genericStatus != c.genericStatus),
          builder: (context, state) {
            return const _View();
          },
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _formKey = GlobalKey<FormState>();

  //late AuthenticationCubit _cubit;
  late TextEditingController _emailController;

  @override
  void initState() {
    //_cubit = context.read<AuthenticationCubit>();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                FormInput(
                  labelText: "Email",
                  hintText: "Ingresar correo electrónico",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validators.emailValidation(value),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: GenericButton(
              text: "Confirmar",
              onTap: () {
                FocusScope.of(context).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();

                if (_formKey.currentState!.validate()) {
                  // cubit.changePassword(
                  //   currentPassword: _currentPasswordController.text,
                  //   newPassword: _passwordController.text,
                  // );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
