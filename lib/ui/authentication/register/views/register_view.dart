import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/utils/local_storage.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/modals/modals.dart';
import 'package:unetpedia/ui/home/views/home_view.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/ui/authentication/authentication.dart';
import 'package:unetpedia/models/authentication/authentication.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';

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
          isWhite: true,
        ),
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
                      userId: state.registerResponseModel?.user?.id.toString(),
                      accessToken: state.loginResponseModel?.accessToken,
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeView.routeName, (Route route) => false);
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
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _cPasswordController;
  late TextEditingController _degreeController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    cubit = context.read<AuthenticationCubit>();

    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cPasswordController = TextEditingController();
    _degreeController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    _degreeController.dispose();
    _descriptionController.dispose();
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
        return SelectDegreeModal(
          onDegreeSelected: (degree) {
            cubit.setDegree(degree);
            _degreeController = TextEditingController(text: degree.name);
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
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (value) => Validators.emptyValidation(value),
            controller: _nameController,
          ),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Apellido",
            hintText: "Ingresar apellido",
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (value) => Validators.emptyValidation(value),
            controller: _lastNameController,
          ),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Email",
            hintText: "Ingresar correo electrónico",
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            validator: (value) => Validators.emailValidation(value),
            controller: _emailController,
          ),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Contraseña",
            hintText: "Ingresar contraseña",
            keyboardType: TextInputType.visiblePassword,
            validator: (value) => Validators.registerPasswordValidation(
                value, _passwordController.text, _cPasswordController.text),
            controller: _passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          FormInput(
            labelText: "Confirmar Contraseña",
            hintText: "Ingresar contraseña",
            keyboardType: TextInputType.visiblePassword,
            validator: (value) => Validators.registerPasswordValidation(
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
                  keyboardType: TextInputType.text,
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
          const SizedBox(height: 24),
          FormInput(
            labelText: "Descripción",
            hintText: "Ingresar descripción",
            minLines: 4,
            maxLines: 4,
            maxLength: 200,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) => Validators.emptyValidation(value),
            controller: _descriptionController,
          ),
          const SizedBox(height: 48),
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
              buildWhen: (p, c) => (p.photoSelected != c.photoSelected ||
                  p.degreeSelected != c.degreeSelected),
              builder: (context, state) {
                return GenericButton(
                  text: "Registrar",
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    // Validando el formulario
                    if (_formKey.currentState!.validate() &&
                        state.degreeSelected?.id != null &&
                        state.photoSelected != null) {
                      // Creando entidad de registro
                      final body = RegisterRequestModel(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                        name: _nameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        description: _descriptionController.text.trim(),
                        career: state.degreeSelected!.id!,
                        role: 2, // 1 Tutor, 2 Estudiante
                        profilePhotoName: state.photoSelected!.name,
                      );

                      // Consumiendo el endpoint de registro
                      cubit.register(body);
                    }
                  },
                );
              }),
        ],
      ),
    );
  }
}
