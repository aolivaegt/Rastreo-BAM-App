import 'package:flutter/material.dart';
import 'package:rastreo_bam/themes/app_theme.dart';

class InfoError extends StatelessWidget {
  const InfoError({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.error),
            ),
            SizedBox(height: 10),
            Text(
              'Ha ocurrido un error',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
