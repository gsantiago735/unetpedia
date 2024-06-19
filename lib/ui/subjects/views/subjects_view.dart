import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/utils/debouncer.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/ui/subjects/views/views.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/core/constants/constants_images.dart';
import 'package:unetpedia/models/subject/subjects_response_model.dart';

class SubjectsView extends StatefulWidget {
  const SubjectsView({super.key});
  static const String routeName = 'subjects_view';

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  late GeneralCubit cubit;

  @override
  void initState() {
    cubit = context.read<GeneralCubit>();
    cubit.getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "Asignaturas"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          const SizedBox(height: 28),
          Expanded(
            child: BlocBuilder<GeneralCubit, GeneralState>(
                buildWhen: (p, c) => (p.subjectsStatus != c.subjectsStatus),
                builder: (context, state) {
                  switch (state.subjectsStatus) {
                    case WidgetStatus.loading:
                      return const Center(child: LoadingIndicator());
                    case WidgetStatus.error:
                      return const Center(child: GenericErrorComponent());
                    case WidgetStatus.success:
                      return Column(
                        children: [
                          GenericTitle(
                              title: state.categorySelected?.name ?? "N/A"),
                          const SizedBox(height: 16),
                          const _Content(),
                        ],
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                }),
          ),
        ],
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
  late GeneralCubit cubit;
  late ScrollController scrollController;

  @override
  void initState() {
    cubit = context.read<GeneralCubit>();
    scrollController = ScrollController();

    scrollController.addListener(() {
      double position = scrollController.position.pixels;
      double maxExtend = scrollController.position.maxScrollExtent;
      if (position > maxExtend - 30) {
        cubit.getSubjects();
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
    return BlocBuilder<GeneralCubit, GeneralState>(
        buildWhen: (p, c) =>
            (p.subjectsResponseModel != c.subjectsResponseModel ||
                p.moreSubjectsStatus != c.moreSubjectsStatus),
        builder: (context, state) {
          List<Widget> children = [];

          for (SubjectResponseModel? subject
              in state.subjectsResponseModel!.data!) {
            children.add(GenericCard(
              title: subject?.name ?? "N/A",
              subtitle: subject?.countSubject?.countText ?? "N/A",
              asset: ConstantImages.redCard,
              onPressed: () {
                cubit.selectSubject(subject);
                Navigator.pushNamed(context, SubjectDetailView.routeName);
              },
            ));
          }

          if (state.moreSubjectsStatus == WidgetStatus.loading) {
            children.add(const Center(child: LoadingIndicator()));
          }

          if (state.moreSubjectsStatus == WidgetStatus.error) {
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
        controller: TextEditingController(
            text: context.read<GeneralCubit>().state.subjectQuery),
        hintText: "Buscar Materia",
        prefixIcon: Icons.search_rounded,
        onChange: (value) {
          _debouncer.run(() {
            context.read<GeneralCubit>().setSubjectQuery(value);
            context.read<GeneralCubit>().getSubjects();
          });
        },
      ),
    );
  }
}
