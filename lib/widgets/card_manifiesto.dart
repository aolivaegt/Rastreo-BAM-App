import 'package:flutter/material.dart';
import 'package:rastreo_bam/models/models.dart' show Manifiesto;
import 'package:rastreo_bam/themes/app_theme.dart';

class CardManifiesto extends StatelessWidget {
  final Manifiesto manifiesto;
  const CardManifiesto({required this.manifiesto, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.3),
            blurRadius: 7,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          _LineCardManifiesto(
              icon: Icons.numbers,
              text: manifiesto.idManifiesto.toString(),
              isTittle: true),
          _LineCardManifiesto(
              icon: Icons.motorcycle,
              text: manifiesto.mensajero ?? '',
              isTittle: false),
          _LineCardManifiesto(
              icon: Icons.calendar_month,
              text: manifiesto.fecha ?? '',
              isTittle: false),
          _LineCardManifiesto(
              icon: Icons.list_alt,
              text: manifiesto.cantidad ?? '0',
              isTittle: false),
        ],
      ),
    );
  }
}

class _LineCardManifiesto extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isTittle;
  const _LineCardManifiesto({
    Key? key,
    required this.text,
    required this.icon,
    required this.isTittle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          margin: const EdgeInsets.only(right: 15, bottom: 5),
          child: Icon(
            icon,
            color: AppTheme.secondary,
          ),
        ),
        isTittle
            ? Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.primary,
                ),
              ),
      ],
    );
  }
}
