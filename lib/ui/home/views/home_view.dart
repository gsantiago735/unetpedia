import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/core/constants/constants_images.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:unetpedia/ui/home/home.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/ui/departments/departments.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'home_view';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late GeneralCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<GeneralCubit>();
    _cubit.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "Unetpedia",
        centerTitle: false,
        isBoldTitle: true,
        needsGoback: false,
        actions: [
          GenericIconButton(
            icon: Icons.drag_handle_rounded,
            onPressed: () {
              Navigator.pushNamed(context, SettingsView.routeName);
            },
          ),
          //const SizedBox(width: 10),
          //_GenericButton(
          //  icon: Icons.notifications_outlined,
          //  onPressed: () {},
          //),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: BlocBuilder<GeneralCubit, GeneralState>(
              buildWhen: (p, c) => (p.getUserStatus != c.getUserStatus),
              builder: (context, state) {
                switch (state.getUserStatus) {
                  case WidgetStatus.loading:
                    return const Center(child: LoadingIndicator());
                  case WidgetStatus.error:
                    return const Center(child: GenericErrorComponent());
                  default:
                    return ListView(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      children: [
                        HomeSectionCard(
                          title: "Asignaturas",
                          description:
                              "Encuentra el contenido de cada materia.",
                          asset: ConstantImages.greenCard,
                          onPressed: () {
                            _cubit.setCategoryQuery("");
                            Navigator.pushNamed(
                                context, DepartmentsView.routeName);
                          },
                        ),
                        const SizedBox(height: 20),
                        HomeSectionCard(
                          title: "Tutores",
                          description:
                              "Encuentra tutor para ayuda en cada materia.",
                          asset: ConstantImages.yellowCard,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 20),
                        HomeSectionCard(
                          title: "Calcula Tu Nota",
                          description:
                              "Calcula lo que te falta para cada parcial.",
                          asset: ConstantImages.blueCard,
                          onPressed: () {},
                        ),
                      ],
                    );
                }
              },
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
    return AppBarLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<GeneralCubit, GeneralState>(
              buildWhen: (p, c) => (p.userResponseModel != c.userResponseModel),
              builder: (context, state) {
                return Text(
                  ((state.userResponseModel?.user?.name ?? "").isNotEmpty)
                      ? "Hola ${state.userResponseModel?.user?.name}."
                      : "Hola ...",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
          const SizedBox(height: 2),
          const Text(
            "Encuentra el contenido que quieres aprender.",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
