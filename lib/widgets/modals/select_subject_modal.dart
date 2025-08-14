import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/widgets/generic_error.dart';
import 'package:unetpedia/ui/cubit/general_cubit.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/subject/subject_model.dart';

class SelectSubjectModal extends StatefulWidget {
  const SelectSubjectModal({
    super.key,
    required this.subjectId,
    required this.onSelected,
  });

  final String? subjectId;
  final void Function(SubjectModel) onSelected;

  @override
  State<SelectSubjectModal> createState() => _SelectSubjectModalState();
}

class _SelectSubjectModalState extends State<SelectSubjectModal> {
  late GeneralCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<GeneralCubit>();

    _cubit.getSubjects(widget.subjectId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Seleccionar Asignatura:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          BlocBuilder<GeneralCubit, GeneralState>(
            buildWhen: (p, c) => (p.subjectsStatus != c.subjectsStatus),
            builder: (context, state) {
              switch (state.subjectsStatus) {
                case WidgetStatus.error:
                  return Expanded(
                    child: Center(
                      child: GenericError(error: state.exception?.details),
                    ),
                  );

                case WidgetStatus.loading:
                  return const Expanded(
                    child: Center(child: LoadingIndicator()),
                  );

                case WidgetStatus.success:
                  return Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: (state.subjects ?? []).length,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          final subject = state.subjects?[index];

                          return _DegreeTile(
                            title: subject?.name ?? "N/A",
                            onPresed: () {
                              if (subject != null) {
                                widget.onSelected(subject);
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _DegreeTile extends StatelessWidget {
  const _DegreeTile({required this.title, required this.onPresed});

  final String title;
  final VoidCallback onPresed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPresed,
      title: Text(title),
      leading: const Icon(Icons.menu_book_rounded),
    );
  }
}
