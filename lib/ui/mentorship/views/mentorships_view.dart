import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/widgets/main_appbar.dart';
import 'package:unetpedia/widgets/generic_error.dart';
import 'package:unetpedia/widgets/generic_title.dart';
import 'package:unetpedia/widgets/loading_indicator.dart';
import 'package:unetpedia/ui/mentorship/views/views.dart';
import 'package:unetpedia/ui/mentorship/cubit/cubit.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/widgets/generic_network_image.dart';
import 'package:unetpedia/models/mentorship/mentorship_model.dart';
import 'package:unetpedia/widgets/buttons/generic_icon_button.dart';

// Listado general de tutorias
class MentorshipsView extends StatelessWidget {
  const MentorshipsView({super.key});
  static const String routeName = 'mentorships_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MentorshipCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MainAppBar(title: "Tutorias"),
        floatingActionButton: _FloatingComponent(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //_Header(),
            const SizedBox(height: 28),
            const Expanded(child: _Content()),
          ],
        ),
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
  late MentorshipCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<MentorshipCubit>();
    _cubit.getMentorships();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MentorshipCubit, MentorshipState>(
      buildWhen: (p, c) => (p.genericStatus != c.genericStatus),
      builder: (context, state) {
        switch (state.genericStatus) {
          case WidgetStatus.loading:
            return const Center(child: LoadingIndicator());
          case WidgetStatus.error:
            return Center(child: GenericError(error: state.exception?.details));
          case WidgetStatus.success:
            return Column(
              children: [
                const GenericTitle(title: "Tutores Disponibles"),
                const SizedBox(height: 16),
                ((state.mentorships ?? []).isEmpty)
                    ? Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "No hemos encontrado resultados para tu búsqueda.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: state.mentorships?.length ?? 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemBuilder: (context, index) =>
                              _CardComponent(state.mentorships?[index]),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                        ),
                      ),
              ],
            );
          default:
            return const Placeholder();
        }
      },
    );
  }
}

class _FloatingComponent extends StatelessWidget {
  const _FloatingComponent();

  @override
  Widget build(BuildContext context) {
    return GenericIconButton(
      icon: Icons.add_box_rounded,
      onPressed: () async {
        await Navigator.pushNamed(context, AddMentorshipView.routeName).then((
          value,
        ) {
          if ((value is! bool) || !context.mounted) return;

          // Evaluando si se ha creado una tutoria de forma satisfactoria
          if (value == true) {
            context.read<MentorshipCubit>().getMentorships();
          }
        });
      },
    );
  }
}

class _CardComponent extends StatelessWidget {
  const _CardComponent(this.item);

  final MentorshipModel? item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MentorshipDetailsView(item: item);
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(0, 4),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 25, 41, 76),
                    width: 2,
                  ),
                ),
                child: GenericNetworkImage(
                  url: item?.ownerUrl,
                  borderRadius: 10,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item?.ownerName ?? "N/A",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item?.subjectName ?? "N/A",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item?.getPrice ?? "N/A",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}
