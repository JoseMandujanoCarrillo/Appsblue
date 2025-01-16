import 'package:flutter/material.dart';

class FormsScreen extends StatelessWidget {
  const FormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Demo de Validación de Formularios';

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  double _sliderValue = 50.0;
  String _selectedOption = 'Opción 1';
  String _selectedDate = '';
  String _selectedTime = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Campo de Nombre
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                hintText: 'Ingresa tu nombre completo',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de Correo Electrónico
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                hintText: 'Ingresa tu correo electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu correo electrónico';
                }
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\$').hasMatch(value)) {
                  return 'Por favor, ingresa un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de Contraseña
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Crea una contraseña segura',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa una contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de Teléfono
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Número de Teléfono',
                hintText: 'Ingresa tu número de teléfono',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu número de teléfono';
                }
                if (!RegExp(r'^\d{10}\$').hasMatch(value)) {
                  return 'Por favor, ingresa un número de 10 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de Dirección
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Dirección',
                hintText: 'Ingresa tu dirección completa',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu dirección';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // CheckBox
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                const Text('Acepto los términos y condiciones'),
              ],
            ),
            const SizedBox(height: 16),

            // Barra Deslizadora
            Text('Selecciona tu edad: ${_sliderValue.round()} años'),
            Slider(
              value: _sliderValue,
              min: 18,
              max: 100,
              divisions: 82,
              label: _sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Botones de Opción
            const Text('Elige una opción:'),
            ListTile(
              title: const Text('Opción 1'),
              leading: Radio<String>(
                value: 'Opción 1',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Opción 2'),
              leading: Radio<String>(
                value: 'Opción 2',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Selector de Fecha
            ListTile(
              title: const Text('Selecciona una fecha'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
            ),
            Text(_selectedDate.isEmpty ? 'No se ha seleccionado fecha' : 'Fecha seleccionada: $_selectedDate'),
            const SizedBox(height: 16),

            // Selector de Hora
            ListTile(
              title: const Text('Selecciona una hora'),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _selectedTime = selectedTime.format(context);
                    });
                  }
                },
              ),
            ),
            Text(_selectedTime.isEmpty ? 'No se ha seleccionado hora' : 'Hora seleccionada: $_selectedTime'),
            const SizedBox(height: 16),

            // Botón de Enviar
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Procesando información...')),
                  );
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
