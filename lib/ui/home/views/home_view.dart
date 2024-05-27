import 'package:flutter/material.dart';
import 'package:unetpedia/ui/home/home.dart';
import 'package:unetpedia/ui/subjects/subjects.dart';
import 'package:unetpedia/widgets/widgets.dart';
import 'package:unetpedia/core/constants/constants.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = 'home_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "Unetpedia",
        centerTitle: false,
        isBoldTitle: true,
        needsGoback: false,
        actions: [
          _GenericButton(
            icon: Icons.drag_handle_rounded,
            onPressed: () {},
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
          const SizedBox(height: 28),
          HomeSectionCard(
            title: "Asignaturas",
            description: "Encuentra el contenido de cada materia.",
            onPressed: () {
              Navigator.pushNamed(context, SubjectsView.routeName);
            },
          ),
          const SizedBox(height: 20),
          HomeSectionCard(
            title: "Tutores",
            description: "Encuentra tutor para ayuda en cada materia.",
            onPressed: () {},
          ),
          const SizedBox(height: 20),
          HomeSectionCard(
            title: "Calcula Tu Nota",
            description: "Calcula lo que te falta para cada parcial.",
            onPressed: () {},
          ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hola Santiago.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
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

class _GenericButton extends StatelessWidget {
  const _GenericButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 24,
      //visualDensity: VisualDensity.compact,
      color: ConstantColors.cff141718,
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(width: 2, color: Color(0xFFD9D9D9)),
        )),
      ),
    );
  }
}
