import 'package:flutter/material.dart';

class NoDataCard extends StatelessWidget {
  final String? title;
  final String description;
  final EdgeInsetsGeometry? margin;

  const NoDataCard({
    super.key,
    this.title,
    required this.description,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null)
            Text(
              textAlign: TextAlign.center,
              title!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          if (title != null) const SizedBox(height: 12),
          Text(
            textAlign: TextAlign.center,
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
