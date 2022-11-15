import 'package:flutter/material.dart';
import 'package:rastreo_bam/models/models.dart' show Manifiesto;
import 'package:rastreo_bam/widgets/widgets.dart' show CardManifiesto, NoInfo;

class ListaManifiestos extends StatelessWidget {
  final List<Manifiesto> manifiestos;
  const ListaManifiestos(this.manifiestos, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool vacio = manifiestos.isEmpty;
    return vacio
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            itemCount: 1,
            itemBuilder: (BuildContext context, int i) {
              return const NoInfo();
            },
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            itemCount: manifiestos.length,
            itemBuilder: (BuildContext context, int i) {
              return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'manifest_detail',
                      arguments: manifiestos[i].nManifiesto),
                  child: CardManifiesto(manifiesto: manifiestos[i]));
            },
          );
  }
}
