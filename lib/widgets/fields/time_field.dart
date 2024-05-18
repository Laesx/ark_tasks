import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ark_jots/utils/tools.dart';

class TimeField extends StatefulWidget {
  const TimeField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  //final DateTime? value;
  final TimeOfDay? value;
  final Function(TimeOfDay?) onChanged;

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  // late DateTime? _value = widget.value;
  late TimeOfDay? _value = widget.value;
  late final _ctrl = TextEditingController(text: Tools.timeToText(_value));

  @override
  void didUpdateWidget(covariant TimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
    final text = Tools.timeToText(_value);
    if (_ctrl.text != text) _ctrl.text = text;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: _ctrl,
      textAlign: TextAlign.center,
      onTap: () => showTimePicker(
        context: context,
        initialTime: _value ?? TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dialOnly,
        confirmText: 'Aceptar',
        cancelText: 'Cancelar',
        helpText: 'Selecciona la hora',
      ).then((pickedDate) {
        if (pickedDate == null) return;

        _value = pickedDate;
        _ctrl.text = Tools.timeToText(_value);
        widget.onChanged(pickedDate);
      }),
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: const InkResponse(
          radius: 10,
          child: Tooltip(
            message: 'Pick Date',
            child: Icon(Ionicons.calendar_clear_outline),
          ),
        ),
      ),
    );
  }
}
