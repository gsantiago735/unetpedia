import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/core/constants/constants_images.dart';
import 'package:unetpedia/utils/debouncer.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/ui/subjects/subjects.dart';
import 'package:unetpedia/ui/cubit/general_cubit.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/documents/documents_response_model.dart';

class SubjectDetailView extends StatelessWidget {
  const SubjectDetailView({super.key});
  static const String routeName = 'subject_detail_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsCubit()
        ..setSubject(context.read<GeneralCubit>().state.subjectSelected),
      child: Scaffold(
        appBar: const MainAppBar(title: "Detalles"),
        floatingActionButton: GenericIconButton(
          icon: Icons.add_box_rounded,
          onPressed: () {
            Navigator.pushNamed(context, AddSubjectDocumentView.routeName);
          },
        ),
        body: const _View(),
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
    cubit.getDocuments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        const SizedBox(height: 28),
        Expanded(
          child: BlocBuilder<SubjectsCubit, SubjectsState>(
              buildWhen: (p, c) =>
                  (p.getDocumentsStatus != c.getDocumentsStatus),
              builder: (context, state) {
                switch (state.getDocumentsStatus) {
                  case WidgetStatus.loading:
                    return const Center(child: LoadingIndicator());
                  case WidgetStatus.error:
                    return const Center(child: GenericErrorComponent());
                  case WidgetStatus.success:
                    return Column(
                      children: [
                        GenericTitle(
                            title: state.subjectSelected?.name ?? "N/A"),
                        const SizedBox(height: 16),
                        const _RenderContent(),
                      ],
                    );
                  default:
                    return const SizedBox.shrink();
                }
              }),
        ),
      ],
    );
  }
}

class _RenderContent extends StatefulWidget {
  const _RenderContent();

  @override
  State<_RenderContent> createState() => __RenderContentState();
}

class __RenderContentState extends State<_RenderContent> {
  late SubjectsCubit cubit;
  late ScrollController scrollController;

  @override
  void initState() {
    cubit = context.read<SubjectsCubit>();
    scrollController = ScrollController();

    scrollController.addListener(() {
      double position = scrollController.position.pixels;
      double maxExtend = scrollController.position.maxScrollExtent;
      if (position > maxExtend - 30) {
        cubit.getDocuments();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectsCubit, SubjectsState>(
        buildWhen: (p, c) => (p.documents != c.documents ||
            p.getMoreDocsStatus != c.getMoreDocsStatus),
        builder: (context, state) {
          List<Widget> children = [];

          for (DocumentResponseModel? document in state.documents!.data!) {
            children.add(SubjectCard(
              title: document?.name ?? "N/A",
              asset: ConstantImages.yellowCard,
              onPressed: () {},
            ));
          }

          if (state.getMoreDocsStatus == WidgetStatus.loading) {
            children.add(const Center(child: LoadingIndicator()));
          }

          if (state.getMoreDocsStatus == WidgetStatus.error) {
            children.add(const GenericErrorComponent());
          }

          return Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: children.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemBuilder: (context, index) => children[index],
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          );
        });
  }
}

class _Header extends StatelessWidget {
  _Header();

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return AppBarLayout(
      child: SearchInput(
        hintText: "Buscar Material",
        controller: TextEditingController(
            text: context.read<SubjectsCubit>().state.documentsQuery),
        prefixIcon: Icons.search_rounded,
        onChange: (value) {
          _debouncer.run(() {
            context.read<SubjectsCubit>().setDocumentsQuery(value);
            context.read<SubjectsCubit>().getDocuments();
          });
        },
      ),
    );
  }
}
