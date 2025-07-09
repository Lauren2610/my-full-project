import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(PokemonApp());
}

class PokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Finder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PokemonHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PokemonHomePage extends StatefulWidget {
  @override
  _PokemonHomePageState createState() => _PokemonHomePageState();
}

class _PokemonHomePageState extends State<PokemonHomePage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _pokemonData;
  String _message = '';
  bool _isLoading = false;
  final String baseUrl = 'http://127.0.0.1:8000/pokedex/api/';

  Future<void> fetchPokemonByNumber(String number) async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'number': number}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data.containsKey('pokemon')) {
          setState(() {
            _pokemonData = data['pokemon'];
            _message = '';
          });
        } else if (data['message'] == 'empty') {
          setState(() {
            _pokemonData = null;
            _message = 'No Pokémon found for number $number';
          });
        }
      } else {
        setState(() {
          _pokemonData = null;
          _message = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _pokemonData = null;
        _message = 'Exception: $e';
        print(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildPokemonCard() {
    if (_pokemonData == null) {
      return Text(_message, style: TextStyle(color: Colors.red));
    }

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _pokemonData!['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Image.network(_pokemonData!['image'], height: 150),
            SizedBox(height: 10),
            Text(
              'Type: ${(_pokemonData!['type'] as List).join(', ')}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Finder')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Pokémon Number (1-7)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  fetchPokemonByNumber(_controller.text);
                }
              },
              child: Text('Find Pokémon'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _pokemonData != null || _message.isNotEmpty
                ? _buildPokemonCard()
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
