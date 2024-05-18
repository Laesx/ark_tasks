import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ark_jots/utils/tools.dart';

class DateField extends StatefulWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final Function(String?) onChanged;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late String? _value = widget.value;
  late final _ctrl = TextEditingController(text: _value);

  @override
  void didUpdateWidget(covariant DateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
    final text = _value ?? "";
    if (_ctrl.text != text) _ctrl.text = text;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  final List<String> weekdays = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo'
  ];

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: _ctrl,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: Semantics(
          button: true,
          child: Material(
            color: Colors.transparent,
            child: InkResponse(
              radius: 10,
              child: const Tooltip(
                message: 'Pick Date',
                child: Icon(Ionicons.calendar_clear_outline),
              ),
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Selecciona el día de la semana'),
                    children: weekdays.map((String day) {
                      return SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, day);
                        },
                        child: Text(day.capitalize()),
                      );
                    }).toList(),
                  );
                },
              ).then((pickedDate) {
                if (pickedDate == null) return;

                _value = pickedDate;
                _ctrl.text = _value ?? '';
                widget.onChanged(pickedDate);
              }),
            ),
          ),
        ),
        suffixIcon: Semantics(
          button: true,
          child: Material(
            color: Colors.transparent,
            child: InkResponse(
              radius: 10,
              child: const Tooltip(
                message: 'Clear',
                child: Icon(Ionicons.close_outline),
              ),
              onTap: () {
                _ctrl.text = '';
                widget.onChanged(null);
              },
            ),
          ),
        ),
      ),
    );
  }

  String _dateToText(DateTime? date) =>
      date != null ? '${date.year}-${date.month}-${date.day}' : '';
}
