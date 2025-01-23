import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Listapi extends StatelessWidget {
  const Listapi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Scroll Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InfiniteScrollPage(),
    );
  }
}

class InfiniteScrollPage extends StatefulWidget {
  const InfiniteScrollPage({super.key});

  @override
  State<InfiniteScrollPage> createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  final List<dynamic> _items = [];
  final int _pageSize = 20;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  final String _apiUrl = 'https://apifixya.onrender.com/users'; // Cambia la ruta según la necesidad

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl?page=$_currentPage&size=$_pageSize'),
        headers: {'Authorization': 'Bearer YOUR_TOKEN'}, // Reemplaza YOUR_TOKEN con el token adecuado
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> newItems = data['users'] ?? [];

        setState(() {
          _items.addAll(newItems);
          _hasMoreData = newItems.length == _pageSize;
          if (_hasMoreData) _currentPage++;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll Example'),
      ),
      body: ListView.builder(
        itemCount: _items.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            _fetchData();
            return const Center(child: CircularProgressIndicator());
          }

          final item = _items[index];
          return ListTile(
            title: Text(item['name'] ?? 'No Name'),
            subtitle: Text(item['email'] ?? 'No Email'),
          );
        },
      ),
    );
  }
}
