import 'package:flutter/material.dart';

class StudentInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const StudentInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Non spécifié',
              style: TextStyle(
                color: value.isNotEmpty ? Colors.black87 : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
