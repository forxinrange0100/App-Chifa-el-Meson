import 'package:delivera/pages/home_page.dart' show HomePage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Colors, MaterialPageRoute, Navigator, Scaffold, ElevatedButton, Icon, Icons, Column, EdgeInsets, Padding, Container;

class ErrorScreenWidget extends StatelessWidget {
  const ErrorScreenWidget({
    super.key,
    required String? errorMessage,
  }) : _errorMessage = errorMessage;

  final String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        // size according to screen size
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.3),
                  Icon(
                    Icons.error,
                    size: 100,
                    color: Colors.red,
                  ),
                  Text("Error", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red)),
                  Text('Ocurrió un error inesperado...', style: TextStyle(fontSize: 18, color: Colors.black54)),
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(top: 12.0, bottom: 24),
                      constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Text(_errorMessage),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: ElevatedButton(
          onPressed: () => _navigateHome(context),
          child: const Text("Volver al inicio", style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

void _navigateHome(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const HomePage(),
    ),
    (route) => false,
  );
}
