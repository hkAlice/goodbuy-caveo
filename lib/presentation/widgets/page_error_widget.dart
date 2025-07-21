import 'package:flutter/material.dart';

class PageErrorWidget extends StatelessWidget {
  final Function onTap;
  const PageErrorWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48),
          const SizedBox(height: 16),
          const Text('Falha ao carregar conteúdo.'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () { onTap(); },
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}