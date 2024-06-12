import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/ui/cubit/general_cubit.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/widgets/generic_error_component.dart';

class SelectDegreeModal extends StatefulWidget {
  const SelectDegreeModal({super.key, required this.onDegreeSelected});

  final void Function(DegreeResponseModel) onDegreeSelected;

  @override
  State<SelectDegreeModal> createState() => _SelectDegreeModalState();
}

class _SelectDegreeModalState extends State<SelectDegreeModal> {
  late GeneralCubit cubit;

  @override
  void initState() {
    cubit = context.read<GeneralCubit>();

    if ((cubit.state.degrees?.data ?? []).isEmpty) {
      cubit.getDegrees();
    }

    super.initState();
  }

  //final List _degrees = const [
  //  "Arquitectura.",
  //  "Ingeniería Civil.",
  //  "Ingeniería Electrónica.",
  //  "Ingeniería Ambiental.",
  //  "Ingeniería Informática.",
  //  "Ingeniería Industrial.",
  //  "Ingeniería Mecánica.",
  //  "Ingeniería en Producción Animal.",
  //  "Licenciatura en Música.",
  //  "Psicología.",
  //  "TSU en Electromedicína.",
  //  "TSU en Entrenamiento Deportivo.",
  //];

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
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Seleccionar Carrera: ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<GeneralCubit, GeneralState>(
                buildWhen: (p, c) => (p.degreesStatus != c.degreesStatus),
                builder: (context, state) {
                  switch (state.degreesStatus) {
                    case WidgetStatus.error:
                      return const Expanded(
                          child: Center(
                        child: GenericErrorComponent(),
                      ));
                    case WidgetStatus.loading:
                      return const Expanded(
                          child: Center(child: LoadingIndicator()));
                    case WidgetStatus.success:
                      return Expanded(
                        child: ListView.builder(
                          itemCount: (state.degrees?.data ?? []).length,
                          itemBuilder: (context, index) {
                            final degree = state.degrees?.data?[index];

                            return _DegreeTile(
                              title: degree?.name ?? "N/A",
                              onPresed: () {
                                if (degree != null) {
                                  widget.onDegreeSelected(
                                      state.degrees!.data![index]);
                                }
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                }),
          ],
        ));
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
