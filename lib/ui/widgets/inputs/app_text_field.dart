import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_constants.dart';

/// Text field réutilisable avec styles cohérents
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: ThemeConstants.spacingSm),
        ],
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon,
            counterText: maxLength != null ? null : '',
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onTap: onTap,
          validator: validator,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          readOnly: readOnly,
        ),
      ],
    );
  }
}

/// Search field avec icône de recherche
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint ?? 'Rechercher...',
        prefixIcon: Icon(Icons.search),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: onClear ??
                    () {
                      controller?.clear();
                      onChanged?.call('');
                    },
              )
            : null,
      ),
      onChanged: onChanged,
    );
  }
}

/// Dropdown réutilisable
class AppDropdown<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final IconData? prefixIcon;
  final FormFieldValidator<T>? validator;
  final bool enabled;

  const AppDropdown({
    super.key,
    this.label,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: ThemeConstants.spacingSm),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          hint: hint != null ? Text(hint!) : null,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.spacingMd,
              vertical: ThemeConstants.spacingSm,
            ),
          ),
        ),
      ],
    );
  }
}

/// Number input field
class AppNumberField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final double? min;
  final double? max;
  final int? decimals;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final String? suffixText;

  const AppNumberField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.min,
    this.max,
    this.decimals = 0,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    final actualDecimals = decimals ?? 0;

    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      prefixIcon: prefixIcon,
      keyboardType: TextInputType.numberWithOptions(
        decimal: actualDecimals > 0,
        signed: min == null || min! < 0,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          actualDecimals > 0 ? RegExp(r'^\d*\.?\d*') : RegExp(r'^\d*'),
        ),
      ],
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) return null;
            final number = double.tryParse(value);
            if (number == null) return 'Nombre invalide';
            if (min != null && number < min!) {
              return 'Doit être ≥ $min';
            }
            if (max != null && number > max!) {
              return 'Doit être ≤ $max';
            }
            return null;
          },
      suffixIcon: suffixIcon,
    );
  }
}

/// Date picker field
class AppDateField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;

  const AppDateField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      readOnly: true,
      prefixIcon: Icons.calendar_today,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime(2100),
        );

        if (date != null) {
          controller.text = _formatDate(date);
          onDateSelected?.call(date);
        }
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

/// Time picker field
class AppTimeField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;

  const AppTimeField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.initialTime,
    this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      readOnly: true,
      prefixIcon: Icons.access_time,
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: initialTime ?? TimeOfDay.now(),
        );

        if (time != null) {
          controller.text = time.format(context);
          onTimeSelected?.call(time);
        }
      },
    );
  }
}
