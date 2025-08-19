import 'package:flutter/material.dart';

import '../constants/dimens.dart';

class FilterOptionsList extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final ValueChanged<Map<String, dynamic>> onToggle;

  const FilterOptionsList({
    super.key,
    required this.options,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (_, __) => SizedBox(height: Dimens.spaceSmall),
      itemBuilder: (context, index) {
        final option = options[index];
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            option['title'] as String,
            style: TextStyle(fontSize: Dimens.fontSizeBody),
          ),
          value: option['value'] as bool,
          onChanged: (_) => onToggle(option),
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor: Theme.of(context).colorScheme.onPrimary,
        );
      },
    );
  }
}
