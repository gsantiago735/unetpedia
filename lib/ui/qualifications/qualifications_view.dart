import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/widgets/main_appbar.dart';

// TODO mejorar
class QualificationView extends StatefulWidget {
  const QualificationView({super.key});

  static const String routeName = 'qualifications_view';

  @override
  State<QualificationView> createState() => _QualificationViewState();
}

class _QualificationViewState extends State<QualificationView> {
  final _formKey = GlobalKey<FormState>();

  late GeneralCubit cubit;

  late TextEditingController _percentage;
  late TextEditingController _percentage1;

  late TextEditingController _currentPasswordController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    cubit = context.read<GeneralCubit>();
    _percentage = TextEditingController();
    _percentage1 = TextEditingController();

    _currentPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _percentage.dispose();
    _percentage1.dispose();
    _currentPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MainAppBar(
        title: "Calcula tu Nota",
        isWhite: true,
      ),
      body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: FormInput(
                            labelText: "Porcentaje I",
                            hintText: "Porcentaje",
                            controller: _percentage,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                Validators.emptyValidation(value),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 4,
                          child: FormInput(
                            labelText: "Parcial I",
                            hintText: "Ingresar nota",
                            controller: _currentPasswordController,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                Validators.emptyValidation(value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: FormInput(
                            labelText: "Porcentaje II",
                            hintText: "Porcentaje",
                            controller: _percentage1,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                Validators.emptyValidation(value),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 4,
                          child: FormInput(
                            labelText: "Parcial II",
                            hintText: "Ingresar nota",
                            controller: _passwordController,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                Validators.emptyValidation(value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: GenericButton(
                  text: "Calcular",
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    if (_formKey.currentState!.validate()) {
                      //cubit.changePassword(
                      //  currentPassword: _currentPasswordController.text,
                      //  newPassword: _passwordController.text,
                      //);
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
