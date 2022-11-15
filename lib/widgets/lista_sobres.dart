import 'package:flutter/material.dart';
import 'package:rastreo_bam/models/models.dart'
    show Manifiesto, ManifiestoDetalle;
import 'package:rastreo_bam/services/processes_service.dart';
import 'package:rastreo_bam/widgets/widgets.dart'
    show CardSobre, CustomLoading, InfoError, NoInfo;

class ListaEscaneado extends StatelessWidget {
  final bool cambio;
  const ListaEscaneado(this.cambio, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProcessesService.getManifiestoPendiente(),
      builder: (context, AsyncSnapshot<Manifiesto> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          final sobres = data?.detalle ?? [];
          return ListaSobres(sobres);
        } else if (snapshot.hasError) {
          return const InfoError();
        }

        return const CustomLoading('Cargando...');
      },
    );
  }
}

class ListaSobres extends StatelessWidget {
  final List<ManifiestoDetalle> sobres;
  const ListaSobres(this.sobres, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool vacio = sobres.isEmpty;
    return vacio
        ? const NoInfo()
        : Column(
            children: sobres.map((e) => CardSobre(e.barra ?? '')).toList());
  }
}
