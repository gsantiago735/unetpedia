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
          listenWhen: (p, c) => (p.status != c.status),
          listener: (context, state) async {
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
                if (state.loginResponseModel?.accessToken != null) {
                  // Guardando data en cache
                  await LocalStorage.setSession(
                    userId: state.loginResponseModel?.userId.toString(),
                    accessToken: state.loginResponseModel?.accessToken,
                  );

                  // Guardando credenciales de usuario si es necesario
                  if (state.rememberMe) {
                    await LocalStorage.setCredentials(
                      email: state.email,
                      password: state.password,
                    );
                  } else {
                    await LocalStorage.deleteCredentials();
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, HomeView.routeName);
                }
                break;
              default:
                break;
            }
          },
          buildWhen: (p, c) => (p.status != c.status),
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    const SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 12,
                        ),
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
                ),
                if (state.status == WidgetStatus.loading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.2),
                      child: const Center(child: LoadingIndicator()),
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
  late AuthenticationCubit cubit;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    cubit = context.read<AuthenticationCubit>();
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
                },
              ),
              const _RememberMe(),
              const SizedBox(height: 12),
              //const _ForgotPasswordText(),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GenericButton(
                text: "Iniciar Sesión",
                onTap: () {
                  FocusScope.of(context).unfocus();

                  if (_formKey.currentState!.validate()) {
                    cubit.login(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );
                  }
                },
              ),
              const SizedBox(height: 28),
              const _RegisterText(),
            ],
          ),
        ],
      ),
    );
  }
}

// class _ForgotPasswordText extends StatelessWidget {
//   const _ForgotPasswordText();
//
//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         children: [
//           const TextSpan(
//             text: '¿Olvidaste tu contraseña?',
//             style: TextStyle(
//               color: Color(0xFF6C6C6C),
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const TextSpan(text: ' '),
//           TextSpan(
//             text: 'Recuperar',
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: ConstantColors.cff141718,
//               //fontWeight: FontWeight.bold,
//             ),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                 Navigator.pushNamed(context, ForgotPasswordView.routeName);
//               },
//           ),
//         ],
//       ),
//     );
//   }
// }

class _RegisterText extends StatelessWidget {
  const _RegisterText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(
            text: '¿No tienes cuenta?',
            style: TextStyle(
              color: Color(0xFF6C6C6C),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: 'Regístrate',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ConstantColors.cff141718,
              //fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, RegisterView.routeName);
              },
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
