import 'package:flutter/material.dart';

class CardSobre extends StatelessWidget {
  final String barra;
  const CardSobre(this.barra, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      child: ListTile(
        leading: const Icon(Icons.numbers),
        title: Text(barra),
      ),
    );
  }
}
