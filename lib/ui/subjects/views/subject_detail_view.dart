import 'package:flutter/material.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/ui/subjects/subjects.dart';

class SubjectDetailView extends StatelessWidget {
  const SubjectDetailView({super.key});
  static const String routeName = 'subject_detail_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        title: "Detalles",
      ),
      body: Column(
        children: [
          const _Header(),
          const SizedBox(height: 28),
          const GenericTitle(title: "Nombre de Materia Aqui"),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemBuilder: (context, index) {
                return SubjectCard(
                  title: "Tabla de Derivadas Definidas",
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
      child: SearchInput(
        hintText: "Buscar Material",
        prefixIcon: Icons.search_rounded,
      ),
    );
  }
}
