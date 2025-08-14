import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/widgets/generic_error.dart';
import 'package:unetpedia/ui/cubit/general_cubit.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/subject/department_model.dart';

class SelectDepartmentModal extends StatefulWidget {
  const SelectDepartmentModal({super.key, required this.onSelected});

  final void Function(DepartmentModel) onSelected;

  @override
  State<SelectDepartmentModal> createState() => _SelectDepartmentModalState();
}

class _SelectDepartmentModalState extends State<SelectDepartmentModal> {
  late GeneralCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<GeneralCubit>();

    if ((_cubit.state.departments ?? []).isEmpty) {
      _cubit.getDepartments();
    }

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
            "Seleccionar Departamento: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          BlocBuilder<GeneralCubit, GeneralState>(
            buildWhen: (p, c) => (p.departmentsStatus != c.departmentsStatus),
            builder: (context, state) {
              switch (state.departmentsStatus) {
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
                        itemCount: (state.departments ?? []).length,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          final department = state.departments?[index];

                          return _DegreeTile(
                            title: department?.name ?? "N/A",
                            onPresed: () {
                              if (department != null) {
                                widget.onSelected(department);
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
