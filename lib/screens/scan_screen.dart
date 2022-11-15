import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:rastreo_bam/models/models.dart'
    show Manifiesto, ManifiestoDetalle, Mensajero, ProcesarLD, Respuesta;
import 'package:rastreo_bam/providers/providers.dart';
import 'package:rastreo_bam/services/permissions_service.dart';
import 'package:rastreo_bam/services/services.dart';
import 'package:rastreo_bam/themes/app_theme.dart';
import 'package:rastreo_bam/ui/inputs_decoration.dart';
import 'package:rastreo_bam/widgets/widgets.dart'
    show Alert, CustomLoading, InfoError, ListaSobres;

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();

  static bool cambio = false;
}

class _ScanScreenState extends State<ScanScreen> {
  Future<Manifiesto>? _manifiesto;

  Future update() async {
    setState(() {
      ScanScreen.cambio = !ScanScreen.cambio;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    final LDFromProvider ldForm = Provider.of<LDFromProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () => update(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: FutureBuilder(
          future: ProcessesService.getManifiestoPendiente(),
          builder: (context, AsyncSnapshot<Manifiesto> snapshot) {
            if (snapshot.hasData) {
              final manifiesto = snapshot.data;
              final List<ManifiestoDetalle> sobres = manifiesto?.detalle ?? [];
              final List<Mensajero> mensajeros = manifiesto?.mensajeros ??
                  [Mensajero(idMensajero: 0, nombre: 'No hay mensajeros')];
              final mj = manifiesto?.idMensajero ?? Manifiesto().idMensajero;

              final int mensajeroManif =
                  mj == null || mj.isEmpty ? 0 : int.parse(mj.toString());

              ldForm.idMensajero =
                  mensajeroManif != 0 ? mensajeroManif : ldForm.idMensajero;

              return Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: ldForm.formkey,
                      child: Column(
                        children: [
                          mensajeroManif != 0
                              ? _ListaMensajero(mensajeroManif,
                                  manifiesto?.mensajero ?? 'No hay')
                              : _ListaMensajeros(mensajeros, ldForm),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: TextFormField(
                                    controller: ldForm.barraController,
                                    autocorrect: false,
                                    decoration: InputsDecorations.authInput(
                                        hintText: 'Barra', label: 'Barra'),
                                    onChanged: (value) {
                                      ldForm.barra = value;
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  color: Colors.white,
                                  onPressed: () async {
                                    await PermissionsService.getPermitions()
                                        .then((value) {
                                      if (value) {
                                        _procesarLD(context, ldForm,
                                                manifiesto?.nManifiesto ?? '')
                                            .then((value) {
                                          if (value) {
                                            setState(() {});
                                          }
                                        });
                                      } else {
                                        EasyLoading.showError(
                                            'El permiso de la cámara es requerido');
                                      }
                                    });
                                  },
                                  icon: const Center(
                                      child: Icon(Icons.qr_code, size: 40)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          if (manifiesto?.nManifiesto != null)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    AppTheme.primary,
                                  ),
                                ),
                                onPressed: () async {
                                  if (manifiesto?.nManifiesto != null) {
                                    await _cerrarManifiesto(
                                            context,
                                            manifiesto?.nManifiesto ?? '',
                                            ldForm)
                                        .then((value) {
                                      if (value) {
                                        setState(() {});
                                      }
                                    });
                                  } else {
                                    return;
                                  }
                                },
                                child: const Text(
                                  'Cerrar Manifiesto',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (manifiesto?.nManifiesto != null)
                            Text(
                              'Manifiesto: ${manifiesto?.nManifiesto}',
                              style: const TextStyle(fontSize: 20),
                            ),
                        ],
                      ),
                    ),
                  ),
                  ListaSobres(sobres),
                  if (sobres.isNotEmpty) const SizedBox(height: 20)
                ],
              );
            } else if (snapshot.hasError) {
              return const InfoError();
            }

            return SizedBox(
              height: size.height * 0.6,
              child: const CustomLoading('Cargando...'),
            );
          },
        ),
      ),
    );
  }
}

class _ListaMensajeros extends StatelessWidget {
  final List<Mensajero> mensajeros;
  final LDFromProvider ldForm;
  const _ListaMensajeros(this.mensajeros, this.ldForm);

  @override
  Widget build(BuildContext context) {
    print('Id mensajero 1 --------> ${ldForm.idMensajero}');
    return DropdownButtonFormField(
      value: null,
      decoration: InputsDecorations.authInput(
          hintText: 'Mensajero', label: 'Mensajero'),
      items: mensajeros.map((e) {
        return DropdownMenuItem(
          value: e.idMensajero,
          child: Text(e.nombre.toString()),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          ldForm.idMensajero = 0;
        } else {
          ldForm.idMensajero = int.parse(value.toString());
        }
        print('camibo de alor ${ldForm.idMensajero}');
      },
    );
  }
}

class _ListaMensajero extends StatelessWidget {
  final int idMensajero;
  final String nombre;
  const _ListaMensajero(this.idMensajero, this.nombre);

  @override
  Widget build(BuildContext context) {
    print('valores --------- $idMensajero - $nombre');
    return DropdownButtonFormField(
      value: idMensajero,
      decoration: InputsDecorations.authInput(
          hintText: 'Mensajero', label: 'Mensajero'),
      items: [
        DropdownMenuItem(
          value: idMensajero,
          child: Text(nombre.toString()),
        )
      ],
      onChanged: null,
    );
  }
}

Future<bool> _procesarLD(
  BuildContext context,
  LDFromProvider ldForm,
  String? nManifiesto,
) async {
  FocusScope.of(context).unfocus();

  if (ldForm.idMensajero == null || ldForm.idMensajero == 0) {
    await EasyLoading.showError('Seleccione un mensajero');
    return false;
  }

  if (ldForm.barra.isEmpty) {
    String? codeScanner = await Scanner.scanBarcode();

    if (codeScanner == null) {
      await EasyLoading.showError('Lectura inválida');
      return false;
    }

    ldForm.barra = codeScanner;
  }

  await EasyLoading.show(
    status: 'Procesando Salida a ruta...',
    maskType: EasyLoadingMaskType.black,
  );

  await ProcessesService.procesarLD(
          ldForm.idMensajero, ldForm.barra, nManifiesto ?? '')
      .then((ProcesarLD data) {
    EasyLoading.dismiss();

    ldForm.barra = '';
    ldForm.barraController.clear();

    if (data.codigo == 200) {
      ldForm.cambio = true;
      ScanScreen.cambio = true;
      Alert(context, title: 'Salida a Ruta', text: data.mensaje);
      return true;
    } else {
      Alert(context, title: 'Error', text: data.mensaje);
    }
  });
  return false;
}

Future<bool> _cerrarManifiesto(
    BuildContext context, String nManifiesto, LDFromProvider ldForm) async {
  FocusScope.of(context).unfocus();

  await EasyLoading.show(
    status: 'Procesando...',
    maskType: EasyLoadingMaskType.black,
  );

  await ProcessesService.updateManifiesto(nManifiesto).then((Respuesta data) {
    EasyLoading.dismiss();

    if (data.codigo == 200) {
      ldForm.cambio = true;
      Alert(context, title: 'Manifiesto', text: data.mensaje!);
      return true;
    } else {
      Alert(context,
          title: 'Error', text: data.mensaje ?? 'Ha ocurrido un error');
    }
  });

  return false;
}
