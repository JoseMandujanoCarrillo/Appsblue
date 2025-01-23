import 'package:flutter/material.dart';

class AnimationExamplesPage extends StatefulWidget {
  const AnimationExamplesPage({super.key});

  @override
  State<AnimationExamplesPage> createState() => _AnimationExamplesPageState();
}

class _AnimationExamplesPageState extends State<AnimationExamplesPage> with SingleTickerProviderStateMixin {
  // Variables para AnimatedContainer
  bool _isExpanded = false;

  // Variables para FadeTransition
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplos de Animaciones'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ejemplo de AnimatedContainer
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                width: _isExpanded ? 200 : 100,
                height: _isExpanded ? 200 : 100,
                color: _isExpanded ? Colors.blue : Colors.red,
                alignment: Alignment.center,
                child: const Text(
                  'Tap Me!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Ejemplo de FadeTransition
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                '¡Mira cómo aparezco!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              },
              child: const Text('Mostrar/Ocultar Texto'),
            ),
            const SizedBox(height: 20),
            // Ejemplo adicional: Rotación
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RotationExamplePage()),
                );
              },
              child: const Text('Ejemplo de Rotación'),
            ),
          ],
        ),
      ),
    );
  }
}

// Página adicional: Rotación
class RotationExamplePage extends StatefulWidget {
  const RotationExamplePage({super.key});

  @override
  State<RotationExamplePage> createState() => _RotationExamplePageState();
}

class _RotationExamplePageState extends State<RotationExamplePage> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo de Rotación'),
      ),
      body: Center(
        child: RotationTransition(
          turns: _rotationController,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.green,
            child: const Icon(Icons.refresh, color: Colors.white, size: 50),
          ),
        ),
      ),
    );
  }
}
