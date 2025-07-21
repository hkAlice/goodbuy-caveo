import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          VerticalDivider(),
          Text('Carregando')
        ],
      ),
    );
  }
}