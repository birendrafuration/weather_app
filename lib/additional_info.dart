import 'package:flutter/material.dart';

class AdditionlaInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valueText;
  const AdditionlaInformation(
      {super.key,
      required this.icon,
      required this.label,
      required this.valueText});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: screenSize * 0.25,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Icon(
                    icon,
                    size: 32,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    valueText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
