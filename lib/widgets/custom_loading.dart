import 'package:flutter/material.dart';
import 'package:rastreo_bam/themes/app_theme.dart';

class CustomLoading extends StatelessWidget {
  final String mensaje;
  const CustomLoading(this.mensaje, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: AppTheme.secondary,
              strokeWidth: 7,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mensaje,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
