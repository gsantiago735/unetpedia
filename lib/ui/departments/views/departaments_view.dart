import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/utils/debouncer.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/core/constants/constants_images.dart';
import 'package:unetpedia/ui/subjects/views/subjects_view.dart';

class DepartmentsView extends StatelessWidget {
  const DepartmentsView({super.key});
  static const String routeName = 'departments_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "Departamentos"),
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
                        final department =
                            state.categoriesResponseModel?.data?[index];
                        return GenericCard(
                          title: department?.name ?? "N/A",
                          subtitle:
                              "${department?.count?.subject.toString()} Materias",
                          asset: ConstantImages.blueCard,
                          onPressed: () {
                            cubit.selectCategory(department);
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
  _Header();

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return AppBarLayout(
      child: SearchInput(
        controller: TextEditingController(
            text: context.read<GeneralCubit>().state.categoryQuery),
        hintText: "Buscar Departamento",
        prefixIcon: Icons.search_rounded,
        onChange: (value) {
          _debouncer.run(() {
            context.read<GeneralCubit>().setCategoryQuery(value);
            context.read<GeneralCubit>().getCategories();
          });
        },
      ),
    );
  }
}
