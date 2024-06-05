import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/ui/authentication/authentication.dart';
import 'package:unetpedia/widgets/modals/modals.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  static const String routeName = 'register_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: Scaffold(
        appBar: const MainAppBar(
          title: "Registro",
          titleColor: Colors.black,
          backgroundColor: Colors.white,
          leadingIconColor: Colors.black,
        ),
        body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            buildWhen: (p, c) => (p.status != c.status),
            builder: (context, state) {
              return Stack(
                children: [
                  const _Content(),
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

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => __ContentState();
}

class __ContentState extends State<_Content> {
  final _formKey = GlobalKey<FormState>();
  late AuthenticationCubit cubit;

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _cPasswordController;
  late TextEditingController _degreeController;

  @override
  void initState() {
    cubit = context.read<AuthenticationCubit>();

    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cPasswordController = TextEditingController();
    _degreeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    _degreeController.dispose();
    super.dispose();
  }

  void _imageSelectionModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return UploadModal(
          onGetImage: (image) => cubit.setImage(image),
        );
      },
    );
  }

  void _degreeSelectionModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.4,
          maxHeight: MediaQuery.of(context).size.height * 0.4),
      builder: (context) {
        return DegreeModal(
          degree: (degree) {
            cubit.setDegree(degree);
            _degreeController = TextEditingController(text: degree);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        children: [
          const Text(
            "Completa el Formulario",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
              buildWhen: (p, c) => (p.photoSelected != c.photoSelected),
              builder: (context, state) {
                return PhotoComponent(
                  imageSelected: state.photoSelected,
                  onPressed: () => _imageSelectionModal(),
                );
              }),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Nombre",
            hintText: "Ingresar nombre",
            textInputType: TextInputType.name,
            validator: (value) => Validators.emptyValidation(value),
            controller: _nameController,
          ),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Apellido",
            hintText: "Ingresar apellido",
            textInputType: TextInputType.name,
            validator: (value) => Validators.emptyValidation(value),
            controller: _surnameController,
          ),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Email",
            hintText: "Ingresar correo electrónico",
            textInputType: TextInputType.emailAddress,
            validator: (value) => Validators.emailValidation(value),
            controller: _emailController,
          ),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Contraseña",
            hintText: "Ingresar contraseña",
            textInputType: TextInputType.visiblePassword,
            validator: (value) => Validators.passwordValidation(
                value, _passwordController.text, _cPasswordController.text),
            controller: _passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Confirmar Contraseña",
            hintText: "Ingresar contraseña",
            textInputType: TextInputType.visiblePassword,
            validator: (value) => Validators.passwordValidation(
                value, _passwordController.text, _cPasswordController.text),
            controller: _cPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
              buildWhen: (p, c) => (p.degreeSelected != c.degreeSelected),
              builder: (context, state) {
                return FormInput(
                  labelText: "Seleccionar Carrera",
                  hintText: "Selecciona",
                  textInputType: TextInputType.text,
                  validator: (value) => Validators.emptyValidation(value),
                  controller: _degreeController,
                  readOnly: true,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 24,
                    color: Color(0xFF9CA4AB),
                  ),
                  onPressed: () => _degreeSelectionModal(),
                );
              }),
          const SizedBox(height: 48),
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
              buildWhen: (p, c) => (p.photoSelected != c.photoSelected),
              builder: (context, state) {
                return GenericButton(
                  text: "Registrar",
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    if (_formKey.currentState!.validate() &&
                        state.photoSelected != null) {
                      cubit.register();
                    }
                  },
                );
              }),
        ],
      ),
    );
  }
}
