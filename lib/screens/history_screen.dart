import 'package:flutter/material.dart';
import 'package:rastreo_bam/models/models.dart' show Manifiesto;
import 'package:rastreo_bam/services/services.dart' show ProcessesService;
import 'package:rastreo_bam/widgets/widgets.dart'
    show CustomLoading, InfoError, ListaManifiestos;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<Manifiesto>>? _listadoManifiesto;
  bool isLoading = false;

  Future update() async {
    setState(() {
      _listadoManifiesto = ProcessesService.getManifiestos();
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    _listadoManifiesto = ProcessesService.getManifiestos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _listadoManifiesto,
      builder: (context, AsyncSnapshot<List<Manifiesto>> snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
              onRefresh: () => update(),
              child: ListaManifiestos(snapshot.data ?? []));
        } else if (snapshot.hasError) {
          return const InfoError();
        }

        return const CustomLoading('Cargando...');
      },
    );
  }
}
