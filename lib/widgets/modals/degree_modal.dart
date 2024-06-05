import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DegreeModal extends StatelessWidget {
  const DegreeModal({super.key, required this.degree});

  final void Function(String) degree;

  final List _degrees = const [
    "Informatica",
    "Electronica",
    "Ambiental",
    "Industrial",
    "Psicologia",
    "Mecanica",
    "Produccion Animal",
    "Musica",
    "Deportivo",
    "Civil",
    "Arquitectura"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _degrees.length,
                itemBuilder: (context, index) {
                  return _DegreeTile(
                    title: _degrees[index],
                    onPresed: () {
                      degree(_degrees[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class _DegreeTile extends StatelessWidget {
  const _DegreeTile({required this.title, required this.onPresed});

  final String title;
  final VoidCallback onPresed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPresed,
      title: Text(title),
      leading: const Icon(Icons.menu_book_rounded),
    );
  }
}
