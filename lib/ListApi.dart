import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CombinedListApi extends StatelessWidget {
  const CombinedListApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined Infinite Scroll',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://apifixya.onrender.com/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfiniteScrollPage(token: token),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.')),
        );
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
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}

class InfiniteScrollPage extends StatefulWidget {
  final String token;

  const InfiniteScrollPage({super.key, required this.token});

  @override
  State<InfiniteScrollPage> createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  final List<dynamic> _items = [];
  final int _pageSize = 20;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;

  final List<String> _apiUrls = [
    'https://apifixya.onrender.com/users',
    'https://apifixya.onrender.com/services',
    'https://apifixya.onrender.com/proposals',
  ];

  int _currentApiIndex = 0;

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
      final String currentApiUrl = _apiUrls[_currentApiIndex];
      final response = await http.get(
        Uri.parse('$currentApiUrl?page=$_currentPage&size=$_pageSize'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> newItems = data['users'] ?? data['data'] ?? data['proposals'] ?? [];

        setState(() {
          _items.addAll(newItems);
          _hasMoreData = newItems.length == _pageSize;

          if (_hasMoreData) {
            _currentPage++;
          } else {
            // Cambia a la siguiente API cuando los datos de la actual se terminen
            _currentApiIndex++;
            if (_currentApiIndex < _apiUrls.length) {
              _currentPage = 1;
              _hasMoreData = true;
            }
          }
        });
      } else {
        throw Exception('Failed to load data from API');
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
        title: const Text('Combined Infinite Scroll'),
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
            title: Text(item['name'] ?? item['description'] ?? 'No Name/Description'),
            subtitle: Text(item['email'] ?? item['status'] ?? 'No Email/Status'),
          );
        },
      ),
    );
  }
}
