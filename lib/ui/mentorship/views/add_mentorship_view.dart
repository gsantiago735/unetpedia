import 'package:flutter/material.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/widgets/modals/select_subject_modal.dart';
import 'package:unetpedia/ui/mentorship/cubit/mentorship_cubit.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';
import 'package:unetpedia/widgets/modals/select_department_modal.dart';
import 'package:unetpedia/models/mentorship/mentorship_request_model.dart';

// Formulario para agregar tutorias
class AddMentorshipView extends StatelessWidget {
  const AddMentorshipView({super.key});
  static const String routeName = 'add_mentorship_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MentorshipCubit(),
      child: Scaffold(
        appBar: MainAppBar(title: "Agregar Tutoria", isWhite: true),
        body: BlocListener<MentorshipCubit, MentorshipState>(
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
                  barrierDismissible: false,
                  builder: (context) => GenericStatusDialog(
                    description: state.exception?.details,
                    isErrorDialog: true,
                  ),
                );
                break;

              case WidgetStatus.success:
                Navigator.pop(context);
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => PopScope(
                    canPop: false,
                    child: GenericStatusDialog(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                );
                break;

              default:
                break;
            }
          },
          child: const _View(),
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

  late MentorshipCubit _cubit;
  late TextEditingController _departmentCont;
  late TextEditingController _subjectCont;
  late TextEditingController _descriptionCont;
  late TextEditingController _phoneCont;
  late TextEditingController _priceCont;

  @override
  void initState() {
    _cubit = context.read<MentorshipCubit>();

    _departmentCont = TextEditingController();
    _subjectCont = TextEditingController();
    _descriptionCont = TextEditingController();
    _phoneCont = TextEditingController();
    _priceCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _departmentCont.dispose();
    _subjectCont.dispose();
    _descriptionCont.dispose();
    _phoneCont.dispose();
    _priceCont.dispose();
    super.dispose();
  }

  void _departmentSelectionModal() {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: SelectDepartmentModal(
            onSelected: (department) {
              _cubit.selectDepartment(department);
              _cubit.selectSubject(null);

              _departmentCont = TextEditingController(text: department.name);
              _subjectCont = TextEditingController(text: "");
            },
          ),
        );
      },
    );
  }

  void _subjectSelectionModal() {
    if (_cubit.state.departmentSelected == null) return;

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: SelectSubjectModal(
            subjectId: _cubit.state.departmentSelected?.id,
            onSelected: (subject) {
              _cubit.selectSubject(subject);

              _subjectCont = TextEditingController(text: subject.name);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Scrollbar(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                children: [
                  BlocBuilder<MentorshipCubit, MentorshipState>(
                    buildWhen: (p, c) =>
                        (p.departmentSelected != c.departmentSelected),
                    builder: (context, state) {
                      return FormInput(
                        readOnly: true,
                        labelText: "Departamento",
                        hintText: "Seleccionar departamento",
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24,
                          color: Color(0xFF9CA4AB),
                        ),
                        controller: _departmentCont,
                        keyboardType: TextInputType.text,
                        onPressed: () => _departmentSelectionModal(),
                        validator: (value) => Validators.emptyValidation(value),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<MentorshipCubit, MentorshipState>(
                    buildWhen: (p, c) =>
                        (p.subjectSelected != c.subjectSelected),
                    builder: (context, state) {
                      return FormInput(
                        readOnly: true,
                        labelText: "Asignatura",
                        hintText: "Seleccionar asignatura",
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24,
                          color: Color(0xFF9CA4AB),
                        ),
                        controller: _subjectCont,
                        keyboardType: TextInputType.text,
                        onPressed: () => _subjectSelectionModal(),
                        validator: (value) => Validators.emptyValidation(value),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  FormInput(
                    labelText: "Descripción",
                    maxLines: 5,
                    hintText: "Ingresar descripción",
                    controller: _descriptionCont,
                    keyboardType: TextInputType.text,
                    validator: (value) => Validators.emptyValidation(value),
                  ),
                  const SizedBox(height: 24),
                  FormInput(
                    labelText: "Número de contacto",
                    hintText: "Ingresar número de teléfono",
                    controller: _phoneCont,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.numberPhoneValidation(value),
                  ),
                  const SizedBox(height: 24),
                  FormInput(
                    labelText: "Precio por hora (divisa)",
                    hintText: "Ingresar precio",
                    controller: _priceCont,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.numberValidation(value, min: 2),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<MentorshipCubit, MentorshipState>(
            //buildWhen: (p, c) => (p.fileSelected != c.fileSelected),
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: GenericButton(
                  text: "Confirmar",
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();

                    final generalCubit = context.read<GeneralCubit>();

                    if (_formKey.currentState!.validate()) {
                      final data = MentorshipRequestModel(
                        ownerName: generalCubit.state.user!.fullName,
                        ownerUrl: generalCubit.state.user!.photoUrl!,
                        subjectName: _subjectCont.text.trim(),
                        description: _descriptionCont.text.trim(),
                        phone: _phoneCont.text.trim(),
                        price: double.tryParse(_priceCont.text)!,
                      );

                      _cubit.createMentorships(
                        userId: generalCubit.state.user?.uid,
                        data: data,
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
