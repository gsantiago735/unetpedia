import 'package:flutter/material.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/ui/subjects/views/subjects_view.dart';

class DepartmentsView extends StatelessWidget {
  const DepartmentsView({super.key});
  static const String routeName = 'departments_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        title: "Departamentos",
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
                return GenericCard(
                  title: "Matemática y Física",
                  subtitle: "10 Asignaturas",
                  onPressed: () {
                    Navigator.pushNamed(context, SubjectsView.routeName);
                  },
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
      child: SearchInput(
        hintText: "Buscar Departamento",
        prefixIcon: Icons.search_rounded,
      ),
    );
  }
}
