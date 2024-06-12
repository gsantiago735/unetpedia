import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/ui/subjects/views/subjects_view.dart';

class DepartmentsView extends StatelessWidget {
  const DepartmentsView({super.key});
  static const String routeName = 'departments_view';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainAppBar(title: "Departamentos"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          SizedBox(height: 28),
          Expanded(child: _Content()),
        ],
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late GeneralCubit cubit;

  @override
  void initState() {
    cubit = context.read<GeneralCubit>();

    if ((cubit.state.categoriesResponseModel?.data ?? []).isEmpty) {
      cubit.getCategories();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneralCubit, GeneralState>(
        buildWhen: (p, c) => (p.categoryStatus != c.categoryStatus),
        builder: (context, state) {
          switch (state.categoryStatus) {
            case WidgetStatus.loading:
              return const Center(child: LoadingIndicator());
            case WidgetStatus.error:
              return const Center(child: GenericErrorComponent());
            case WidgetStatus.success:
              return Column(
                children: [
                  const GenericTitle(title: "Departamento"),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount:
                          state.categoriesResponseModel?.data?.length ?? 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      itemBuilder: (context, index) {
                        final data =
                            state.categoriesResponseModel?.data?[index];
                        return GenericCard(
                          title: data?.name ?? "N/A",
                          subtitle: data?.count?.subject.toString() ?? "0",
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SubjectsView.routeName);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                    ),
                  )
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        });
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
