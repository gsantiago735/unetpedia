import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/generic_error_component.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/ui/subjects/cubit/cubit.dart';

class SubjectDocumentView extends StatelessWidget {
  const SubjectDocumentView({super.key});
  static const String routeName = 'subject_document_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsCubit(),
      child: const Scaffold(
        appBar: MainAppBar(title: "Documento"),
        body: _View(),
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
  late SubjectsCubit cubit;

  @override
  void initState() {
    cubit = context.read<SubjectsCubit>();
    cubit.getDocumentDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectsCubit, SubjectsState>(
      listenWhen: (p, c) => (p.getDocumentsStatus != c.getDocumentsStatus),
      listener: (context, state) {
        // TODO mejorar
        if (state.getDocumentsStatus == WidgetStatus.success) {}
      },
      buildWhen: (p, c) => (p.getDocumentsStatus != c.getDocumentsStatus),
      builder: (context, state) {
        switch (state.getDocumentsStatus) {
          case WidgetStatus.loading:
            return const Center(child: LoadingIndicator());
          case WidgetStatus.error:
            return const Center(child: GenericErrorComponent());
          default:
            return PDFView(
              filePath: state.fileSelected!.file.path,
            );
        }
      },
    );
  }
}
