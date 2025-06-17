import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/utils/validators.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/ui/cubit/general_cubit.dart';
import 'package:unetpedia/ui/subjects/cubit/cubit.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/widgets/modals/upload_file_modal.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';

class AddSubjectDocumentView extends StatelessWidget {
  const AddSubjectDocumentView({super.key});
  static const String routeName = 'add_subject_document_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsCubit()
        ..setSubject(context.read<GeneralCubit>().state.subjectSelected),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MainAppBar(
          title:
              context.read<GeneralCubit>().state.subjectSelected?.name ?? "N/A",
          isWhite: true,
        ),
        body: BlocConsumer<SubjectsCubit, SubjectsState>(
            listenWhen: (p, c) => (p.uploadStatus != c.uploadStatus),
            listener: (context, state) {
              switch (state.uploadStatus) {
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
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => GenericStatusDialog(
                      title: "Operación exitosa.",
                      description: "Archivo subido.",
                      onTap: () {
                        context.read<GeneralCubit>().getSubjects();
                        Navigator.pop(context);
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
            buildWhen: (p, c) => (p.uploadStatus != c.uploadStatus),
            builder: (context, state) {
              return Stack(
                children: [
                  const _View(),
                  if (state.uploadStatus == WidgetStatus.loading)
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

  late SubjectsCubit cubit;
  late TextEditingController _nameController;

  @override
  void initState() {
    cubit = context.read<SubjectsCubit>();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _documentSelectionModal() {
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
        return UploadFileModal(
          onGetFile: (file) => cubit.selectFile(file),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  FormInput(
                    labelText: "Título del Documento",
                    hintText: "Ingresar nombre del archivo",
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    validator: (value) => Validators.emptyValidation(value),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<SubjectsCubit, SubjectsState>(
                      buildWhen: (p, c) => (p.fileSelected != c.fileSelected),
                      builder: (context, state) {
                        return _UploadFile(
                          onPressed: () => _documentSelectionModal(),
                          file: state.fileSelected,
                        );
                      })
                ],
              ),
            ),
            BlocBuilder<SubjectsCubit, SubjectsState>(
                buildWhen: (p, c) => (p.fileSelected != c.fileSelected),
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: GenericButton(
                      text: "Subir Archivo",
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        if (_formKey.currentState!.validate() &&
                            state.fileSelected != null) {
                          final genericCubit = context.read<GeneralCubit>();

                          cubit.createDocument(
                            category: genericCubit.state.categorySelected!.id!,
                          );
                        }
                      },
                    ),
                  );
                }),
          ],
        ));
  }
}

class _UploadFile extends StatelessWidget {
  const _UploadFile({required this.onPressed, this.file});

  final VoidCallback onPressed;
  final FileModel? file;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: (file != null)
              ? ConstantColors.cff141718.withOpacity(0.15)
              : Colors.transparent,
          border: Border.all(color: ConstantColors.cff141718),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_upload_rounded,
              size: 38,
              color: (file != null)
                  ? ConstantColors.cff141718
                  : const Color(0xFFAFAFAF),
            ),
            const SizedBox(height: 16),
            Text(
              (file != null) ? "${file?.name}" : "Cargar Documento",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: (file != null)
                    ? ConstantColors.cff141718
                    : const Color(0xFFAFAFAF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
