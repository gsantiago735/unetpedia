import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/ui/subjects/cubit/cubit.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/subject/document_model.dart';
import 'package:unetpedia/core/constants/constants_images.dart';
import 'package:unetpedia/widgets/buttons/generic_icon_button.dart';
import 'package:unetpedia/widgets/dialogs/generic_status_dialog.dart';

// Detalles de un documento
class SubjectDocumentView extends StatelessWidget {
  const SubjectDocumentView({super.key, this.document});
  static const String routeName = 'subject_document_view';

  final DocumentModel? document;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsCubit()..setDocument(document),
      child: Scaffold(
        appBar: MainAppBar(title: "Detalles"),
        body: BlocListener<SubjectsCubit, SubjectsState>(
          listenWhen: (p, c) => (p.getDocumentsStatus != c.getDocumentsStatus),
          listener: (context, state) {
            switch (state.getDocumentsStatus) {
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
                //print("TODO BIEN");
                break;

              default:
                break;
            }
          },
          child: _View(),
        ),
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
  late SubjectsCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<SubjectsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<SubjectsCubit, SubjectsState>(
              buildWhen: (p, c) => (p.documentSelected != c.documentSelected),
              builder: (context, state) {
                return Container(
                  height: 70,
                  width: 70,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    border: BoxBorder.all(color: Color(0xFFD9D9D9)),
                  ),
                  child: SvgPicture.asset(
                    (state.documentSelected?.extension == ".pdf")
                        ? ConstantImages.iconFile
                        : ConstantImages.iconImage,
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                _cubit.state.documentSelected?.name ?? "N/A",
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 4),
            GenericIconButton(
              icon: Icons.download_rounded,
              onPressed: () {
                _cubit.downloadFile(
                  onAlreadyExists: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Parece que ya tienes este archivo."),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FieldComponent(
                title: "Fecha de creación",
                description:
                    _cubit.state.documentSelected?.createdAt.toString() ??
                    "N/A",
              ),
            ),
            BlocBuilder<GeneralCubit, GeneralState>(
              buildWhen: (p, c) =>
                  (p.departmentSelected != c.departmentSelected),
              builder: (context, state) {
                return Expanded(
                  child: _FieldComponent(
                    title: "Departamento",
                    description:
                        state.departmentSelected?.name ?? "Por definir",
                    isRight: true,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FieldComponent(
                title: "Extensión",
                description: _cubit.state.documentSelected?.extension ?? "N/A",
              ),
            ),
            Expanded(
              child: _FieldComponent(
                title: "ID del documento",
                description: _cubit.state.documentSelected?.id ?? "N/A",
                isRight: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GeneralCubit, GeneralState>(
              buildWhen: (p, c) => (p.subjectSelected != c.subjectSelected),
              builder: (context, state) {
                return Expanded(
                  child: _FieldComponent(
                    title: "Materia",
                    description: state.subjectSelected?.name ?? "Por definir",
                  ),
                );
              },
            ),
            Expanded(
              child: _FieldComponent(
                title: "Tamaño",
                description:
                    "${_cubit.state.documentSelected?.size?.toString()} bytes",
                isRight: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _FieldComponent(
          title: "Nombre del archivo",
          description: _cubit.state.documentSelected?.name ?? "N/A",
          maxLines: 4,
        ),
        BlocBuilder<SubjectsCubit, SubjectsState>(
          buildWhen: (p, c) =>
              (p.downloadPercent != c.downloadPercent ||
              p.getDocumentsStatus != c.getDocumentsStatus),
          builder: (context, state) {
            return (state.getDocumentsStatus == WidgetStatus.loading)
                ? Text(
                    "Descargando... ${((state.downloadPercent ?? 0.0) * 100).toStringAsFixed(2)}%",
                  )
                : SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _FieldComponent extends StatelessWidget {
  const _FieldComponent({
    required this.title,
    required this.description,
    this.isRight = false,
    this.maxLines = 1,
  });

  final String title;
  final String description;
  final bool isRight;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: (isRight)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: (isRight) ? TextAlign.end : TextAlign.start,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        Text(
          description,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: (isRight) ? TextAlign.end : TextAlign.start,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
