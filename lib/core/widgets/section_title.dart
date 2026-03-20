import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        TextButton(
          onPressed: onSeeAll ?? () {},
          child: Row(
            children: [
              Text("Lihat semua", style: TextStyle(color: color)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 12),
            ],
          ),
        ),
      ],
    );
  }
}
