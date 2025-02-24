import 'package:flutter/material.dart';

class BuildDropDown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final IconData icon;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const BuildDropDown(
      {super.key,
      required this.label,
      required this.value,
      required this.items,
      required this.icon,
      required this.onChanged,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: Theme.of(context).colorScheme.primary,
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon, color: Theme.of(context).colorScheme.inversePrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
