import 'package:flutter/material.dart';
import 'package:unetpedia/utils/debouncer.dart';
import 'package:unetpedia/widgets/appbar_layout.dart';
import 'package:unetpedia/widgets/generic_title.dart';
import 'package:unetpedia/widgets/inputs/search_input.dart';
import 'package:unetpedia/widgets/main_appbar.dart';

class TutorsView extends StatefulWidget {
  const TutorsView({super.key});

  static const String routeName = 'tutors_view';

  @override
  State<TutorsView> createState() => _TutorsViewState();
}

class _TutorsViewState extends State<TutorsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "Tutores"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          const SizedBox(height: 28),
          Expanded(
            child: Column(
              children: [
                const GenericTitle(title: "Tutores Disponibles"),
                const SizedBox(height: 16),
                const _Content(),
              ],
            ),
          )
          //Expanded(
          //  child: BlocBuilder<GeneralCubit, GeneralState>(
          //      buildWhen: (p, c) => (p.subjectsStatus != c.subjectsStatus),
          //      builder: (context, state) {
          //        switch (state.subjectsStatus) {
          //          case WidgetStatus.loading:
          //            return const Center(child: LoadingIndicator());
          //          case WidgetStatus.error:
          //            return const Center(child: GenericErrorComponent());
          //          case WidgetStatus.success:
          //            return Column(
          //              children: [
          //                GenericTitle(
          //                    title: "Tutores Disponibles"),
          //                const SizedBox(height: 16),
          //                const _Content(),
          //              ],
          //            );
          //          default:
          //            return const SizedBox.shrink();
          //        }
          //      }),
          //),
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        //controller: scrollController,
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ivan Reyes",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Matemática I",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Flexible(
                    child: Text(
                  "\$5.00",
                ))
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
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
        //controller: TextEditingController(
        //    text: context.read<GeneralCubit>().state.subjectQuery),
        hintText: "Buscar Materia",
        prefixIcon: Icons.search_rounded,
        onChange: (value) {
          _debouncer.run(() {
            //context.read<GeneralCubit>().setSubjectQuery(value);
            //context.read<GeneralCubit>().getSubjects();
          });
        },
      ),
    );
  }
}
