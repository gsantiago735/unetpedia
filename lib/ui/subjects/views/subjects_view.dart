import 'package:flutter/material.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/utils/debouncer.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/core/constants/constants_images.dart';
import 'package:unetpedia/ui/subjects/views/subject_detail_view.dart';

// Listado de materias del departamente seleccionado
class SubjectsView extends StatelessWidget {
  const SubjectsView({super.key});
  static const String routeName = 'subjects_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "Asignaturas"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          const SizedBox(height: 28),
          const Expanded(child: _Content()),
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
  late GeneralCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<GeneralCubit>();
    _cubit.getSubjects(_cubit.state.departmentSelected?.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralCubit, GeneralState>(
      buildWhen: (p, c) => (p.subjectsStatus != c.subjectsStatus),
      builder: (context, state) {
        switch (state.subjectsStatus) {
          case WidgetStatus.loading:
            return const Center(child: LoadingIndicator());
          case WidgetStatus.error:
            return Center(child: GenericError(error: state.exception?.details));
          case WidgetStatus.success:
            return Column(
              children: [
                GenericTitle(title: state.departmentSelected?.name ?? "N/A"),
                const SizedBox(height: 16),
                BlocBuilder<GeneralCubit, GeneralState>(
                  buildWhen: (p, c) =>
                      (p.subjects != c.subjects ||
                      p.subjectsFiltered != c.subjectsFiltered),
                  builder: (context, state) {
                    // Bandera para renderizar el listado filtrado
                    final bool applyFilter = (state.subjectsFiltered != null);

                    if ((applyFilter)
                        ? ((state.subjectsFiltered ?? []).isEmpty)
                        : ((state.subjects ?? []).isEmpty)) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "No hemos encontrado resultados para tu búsqueda.",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        itemCount: (applyFilter)
                            ? (state.subjectsFiltered?.length ?? 0)
                            : (state.subjects?.length ?? 0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemBuilder: (context, index) {
                          final subject = (applyFilter)
                              ? (state.subjectsFiltered?[index])
                              : (state.subjects?[index]);

                          return GenericCard(
                            title: subject?.name ?? "N/A",
                            subtitle: subject?.getFileCount ?? "N/A",
                            asset: ConstantImages.redCard,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();

                              _cubit.selectSubject(subject);
                              Navigator.pushNamed(
                                context,
                                SubjectDetailView.routeName,
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                      ),
                    );
                  },
                ),
              ],
            );
          default:
            return const Placeholder();
        }
      },
    );
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
          text: context.read<GeneralCubit>().state.subjectQuery,
        ),
        hintText: "Buscar materia",
        prefixIcon: Icons.search_rounded,
        onChange: (value) {
          _debouncer.run(() {
            context.read<GeneralCubit>().setSubjectQuery(value);
          });
        },
      ),
    );
  }
}
