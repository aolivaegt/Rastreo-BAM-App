import 'package:flutter/material.dart';
import 'package:rastreo_bam/config/app_config.dart';
import 'package:rastreo_bam/models/models.dart';
import 'package:rastreo_bam/services/processes_service.dart';
import 'package:rastreo_bam/widgets/widgets.dart';

class ManifestDetailScreen extends StatelessWidget {
  const ManifestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String nManifiesto =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle Manifiesto'),
        centerTitle: true,
        toolbarHeight: AppConfig.appBarHeight,
      ),
      body: FutureBuilder(
        future: ProcessesService.getDetalleManifiesto(nManifiesto),
        builder: (context, AsyncSnapshot<Manifiesto> snapshot) {
          if (snapshot.hasData) {
            final manifiesto = snapshot.data;
            final List<ManifiestoDetalle> sobres = manifiesto?.detalle ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _InfoManifiesto(manifiesto ?? Manifiesto(), sobres.length),
                  Column(
                    children: sobres.map((e) {
                      return CardSobre(e.barra ?? '');
                    }).toList(),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const InfoError();
          }
          return const CustomLoading('Cargando...');
        },
      ),
    );
  }
}

class _InfoManifiesto extends StatelessWidget {
  final Manifiesto manifiesto;
  final int total;
  const _InfoManifiesto(this.manifiesto, this.total);

  @override
  Widget build(BuildContext context) {
    const TextStyle tittle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const TextStyle subtitle =
        TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    const TextStyle text = TextStyle(fontSize: 16);

    return Container(
      // padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('${manifiesto.nManifiesto}', style: tittle),
          const SizedBox(height: 10),
          const Text('Mensajero:', style: subtitle),
          Text('${manifiesto.mensajero}', style: text),
          const SizedBox(height: 10),
          const Text('Destinatario:', style: subtitle),
          Text('${manifiesto.destinatario}', style: text),
          const SizedBox(height: 20),
          Text('Cantidad: $total', style: text),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
