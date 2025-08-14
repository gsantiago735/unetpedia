import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:unetpedia/ui/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/utils/local_storage.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';
import 'package:unetpedia/ui/authentication/authentication.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = 'login_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit()
        ..setRememberMe((LocalStorage.getEmail() ?? "").isEmpty ? false : true),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ConstantColors.cff141718,
        body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listenWhen: (p, c) => (p.genericStatus != c.genericStatus),
          listener: (context, state) async {
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
                  barrierDismissible: false,
                  builder: (context) => GenericStatusDialog(
                    description: state.exception?.details,
                    isErrorDialog: true,
                  ),
                );
                break;

              case WidgetStatus.success:

                // Guardando credenciales de usuario si es necesario
                if (state.rememberMe) {
                  await LocalStorage.setCredentials(
                    email: state.email,
                    password: state.password,
                  );
                } else {
                  await LocalStorage.deleteCredentials();
                }

                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeView.routeName,
                  (Route route) => false,
                );
                break;

              default:
                break;
            }
          },
          buildWhen: (p, c) => (p.genericStatus != c.genericStatus),
          builder: (context, state) {
            return Column(
              children: [
                const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 12),
                    child: Text(
                      "Hola, Bienvenido",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 42,
                      horizontal: 24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const _Content(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => __ContentState();
}

class __ContentState extends State<_Content> {
  final _formKey = GlobalKey<FormState>();

  late AuthenticationCubit _cubit;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _cubit = context.read<AuthenticationCubit>();
    _emailController = TextEditingController(text: LocalStorage.getEmail());
    _passwordController = TextEditingController(
      text: LocalStorage.getPassword(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormInput(
                labelText: "Email",
                hintText: "Ingresar correo electrónico",
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                validator: (value) => Validators.emailValidation(value),
                controller: _emailController,
              ),
              const SizedBox(height: 18),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                buildWhen: (p, c) => (p.showPassword != c.showPassword),
                builder: (context, state) {
                  return FormInput(
                    labelText: "Contraseña",
                    hintText: "Ingresar contraseña",
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: state.showPassword,
                    validator: (value) =>
                        Validators.loginPasswordValidation(value),
                    suffixIcon: IconButton(
                      onPressed: () => _cubit.changePasswordVisibility(),
                      icon: Icon(
                        (state.showPassword)
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 24,
                        color: const Color(0xFF9CA4AB),
                      ),
                    ),
                  );
                },
              ),
              const _RememberMe(),
              const SizedBox(height: 12),
              _RichTextComponent(
                value: "¿Olvidaste tu contraseña?",
                actionText: "Recuperar",
                onPressed: () =>
                    Navigator.pushNamed(context, ForgotPasswordView.routeName),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GenericButton(
                text: "Iniciar Sesión",
                onTap: () {
                  FocusScope.of(context).unfocus();
                  FocusManager.instance.primaryFocus?.unfocus();

                  if (_formKey.currentState!.validate()) {
                    _cubit.login(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );
                  }
                },
              ),
              const SizedBox(height: 28),
              _RichTextComponent(
                value: '¿No tienes cuenta?',
                actionText: 'Regístrate',
                onPressed: () =>
                    Navigator.pushNamed(context, RegisterView.routeName),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RichTextComponent extends StatelessWidget {
  const _RichTextComponent({
    required this.value,
    required this.actionText,
    required this.onPressed,
  });

  final String value;
  final String actionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF6C6C6C),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      TextSpan(
        text: value,
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onPressed,
            text: actionText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ConstantColors.cff141718,
            ),
          ),
        ],
      ),
    );
  }
}

class _RememberMe extends StatelessWidget {
  const _RememberMe();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      buildWhen: (p, c) => (p.rememberMe != c.rememberMe),
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Checkbox(
              value: state.rememberMe,
              checkColor: Colors.white,
              activeColor: ConstantColors.cff141718,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onChanged: (value) {
                final cubit = context.read<AuthenticationCubit>();
                cubit.changeRemeberMe();
              },
            ),
            GestureDetector(
              onTap: () {
                final cubit = context.read<AuthenticationCubit>();
                cubit.changeRemeberMe();
              },
              child: const Text('Recuérdame'),
            ),
          ],
        );
      },
    );
  }
}
