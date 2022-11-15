import 'package:flutter/material.dart';
import 'package:rastreo_bam/themes/app_theme.dart';

class NoInfo extends StatelessWidget {
  const NoInfo({super.key});

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
              child: Icon(Icons.info),
            ),
            SizedBox(height: 10),
            Text(
              'No hay información',
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
