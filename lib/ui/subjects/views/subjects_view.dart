import 'package:flutter/material.dart';
import 'package:unetpedia/ui/subjects/subjects.dart';
import 'package:unetpedia/widgets/widgets.dart';

class SubjectsView extends StatelessWidget {
  const SubjectsView({super.key});
  static const String routeName = 'subjects_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        title: "Asignaturas",
      ),
      body: Column(
        children: [
          const _Header(),
          const SizedBox(height: 28),
          const GenericTitle(title: "Departamento"),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemBuilder: (context, index) {
                return SubjectCard(
                  onPressed: () {},
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const AppBarLayout(
      child: TextField(),
    );
  }
}
