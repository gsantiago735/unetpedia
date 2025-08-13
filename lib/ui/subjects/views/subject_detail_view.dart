import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/utils/debouncer.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/ui/subjects/subjects.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/core/constants/constants_images.dart';

// Listado de documentos de la materia seleccionada
class SubjectDetailView extends StatelessWidget {
  const SubjectDetailView({super.key});
  static const String routeName = 'subject_detail_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectsCubit(),
      child: Scaffold(
        appBar: MainAppBar(
          title: context.read<GeneralCubit>().state.departmentSelected!.name!,
        ),
        floatingActionButton: _FloatingComponent(),
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
  late SubjectsCubit _cubit;
  late GeneralCubit _generalCubit;

  @override
  void initState() {
    _cubit = context.read<SubjectsCubit>();
    _generalCubit = context.read<GeneralCubit>();

    _cubit.getFilesBySubject(
      departmentId: _generalCubit.state.departmentSelected?.id,
      subjectId: _generalCubit.state.subjectSelected?.id,
    );

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
            buildWhen: (p, c) => (p.getDocumentsStatus != c.getDocumentsStatus),
            builder: (context, state) {
              switch (state.getDocumentsStatus) {
                case WidgetStatus.loading:
                  return const Center(child: LoadingIndicator());
                case WidgetStatus.error:
                  return Center(
                    child: GenericError(error: state.exception?.details),
                  );
                case WidgetStatus.success:
                  return Column(
                    children: [
                      BlocBuilder<GeneralCubit, GeneralState>(
                        buildWhen: (p, c) =>
                            (p.subjectSelected != c.subjectSelected),
                        builder: (context, state) {
                          return GenericTitle(
                            title: state.subjectSelected?.name ?? "N/A",
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      ((state.documents ?? []).isEmpty)
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                "No hemos encontrado resultados para tu búsqueda.",
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: state.documents?.length ?? 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                itemBuilder: (context, index) {
                                  return SubjectCard(
                                    title:
                                        state.documents?[index].name ?? "N/A",
                                    asset: ConstantImages.yellowCard,
                                    onPressed: () {
                                      Navigator.push<void>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SubjectDocumentView(
                                              document: state.documents?[index],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    onDelete: () {
                                      //Navigator.pushNamed(
                                      //  context,
                                      //  SubjectDocumentView.routeName,
                                      //);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                              ),
                            ),
                    ],
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _FloatingComponent extends StatelessWidget {
  const _FloatingComponent();

  @override
  Widget build(BuildContext context) {
    return GenericIconButton(
      icon: Icons.add_box_rounded,
      onPressed: () async {
        await Navigator.pushNamed(
          context,
          AddSubjectDocumentView.routeName,
        ).then((value) {
          if ((value is! bool) || !context.mounted) return;

          // Evaluando si se ha subido un documento de forma satisfactoria
          if (value == true) {
            final generalState = context.read<GeneralCubit>().state;

            // Recargando el listado de documentos
            context.read<SubjectsCubit>().getFilesBySubject(
              departmentId: generalState.departmentSelected?.id,
              subjectId: generalState.subjectSelected?.id,
            );
          }
        });
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
        hintText: "Buscar Material",
        controller: TextEditingController(
          text: context.read<SubjectsCubit>().state.documentsQuery,
        ),
        prefixIcon: Icons.search_rounded,
        onChange: (value) {
          _debouncer.run(() {
            //context.read<SubjectsCubit>().setDocumentsQuery(value);
            //context.read<SubjectsCubit>().getDocuments();
          });
        },
      ),
    );
  }
}
