import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Demostración Completa';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: const TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      home: const DrawerDemoScreen(),
    );
  }
}

class DrawerDemoScreen extends StatefulWidget {
  const DrawerDemoScreen({super.key});

  static const appTitle = 'Menú Principal';

  @override
  State<DrawerDemoScreen> createState() => _DrawerDemoScreenState();
}

class _DrawerDemoScreenState extends State<DrawerDemoScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Inicio', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
    SnackBarPage(),
    OrientationDemo(),
    TabBarDemo(),
    FontsDemo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(DrawerDemoScreen.appTitle),
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Encabezado del Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Inicio'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('SnackBar'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Orientación'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pestañas (Tabs)'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Fuentes y Tamaños'),
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SnackBarPage extends StatelessWidget {
  const SnackBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: const Text('¡Hola! Este es un SnackBar.'),
            action: SnackBarAction(
              label: 'Deshacer',
              onPressed: () {
                // Código para deshacer alguna acción
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Text('Mostrar SnackBar'),
      ),
    );
  }
}

class OrientationDemo extends StatelessWidget {
  const OrientationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;
    final size = mediaQuery.size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          orientation == Orientation.portrait ? Icons.stay_current_portrait : Icons.stay_current_landscape,
          size: 100,
        ),
        Text(
          'Orientación: ${orientation == Orientation.portrait ? "Vertical" : "Horizontal"}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          'Resolución: ${size.width.toStringAsFixed(0)} x ${size.height.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: const Text('Ejemplo de Pestañas'),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}

class FontsDemo extends StatelessWidget {
  const FontsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Encabezado Grande', style: Theme.of(context).textTheme.displayLarge),
        Text('Título Principal', style: Theme.of(context).textTheme.titleLarge),
        Text('Texto de Cuerpo', style: Theme.of(context).textTheme.bodyMedium),
        const Divider(),
        const Text(
          'Fuente personalizada: Italic y Tamaño 24',
          style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
        ),
        const Text(
          'Fuente personalizada: Negrita y Tamaño 18',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
