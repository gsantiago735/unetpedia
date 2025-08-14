import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/ui/mentorship/cubit/cubit.dart';

class MentorshipDetailsView extends StatelessWidget {
  const MentorshipDetailsView({super.key});
  static const String routeName = 'mentorship_details_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MentorshipCubit(),
      child: Scaffold(
        appBar: MainAppBar(title: "Detalles"),
        body: _View(),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //ClipRRect(
          //  borderRadius: BorderRadius.circular(18),
          //  child: SizedBox(
          //    height: 160,
          //    width: double.infinity,
          //    child: buildImage(args.image),
          //  ),
          //),
          const SizedBox(height: 14),
          Text(
            "args.name",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tutor de asdasdasdasdas",
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PillButton(text: "Sobre Mí", filled: true, onTap: () {}),
              const SizedBox(width: 12),
              _PillButton(
                text: "Agendar una tutoría",
                filled: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Descripción",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "args.about",
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _Stat(icon: Icons.access_time, label: "120 h"),
              _Stat(icon: Icons.groups, label: "100 Estudiantes"),
              _Stat(icon: Icons.star, label: "4.8 Rating"),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _CircleIcon(icon: Icons.facebook),
              SizedBox(width: 14),
              _CircleIcon(icon: Icons.camera_alt),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.text, required this.filled, this.onTap});
  final String text;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = filled ? const Color(0xFF0B2A7E) : Colors.transparent;
    final fg = filled ? Colors.white : const Color(0xFF0B2A7E);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            text,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF0F172A)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.black87,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}
