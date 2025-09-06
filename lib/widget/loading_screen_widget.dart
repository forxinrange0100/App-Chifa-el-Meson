import 'package:flutter/material.dart';

class LoadingScreenWidget extends StatelessWidget {
  const LoadingScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.blue,
              backgroundColor: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Estamos cargando todo para ti, espera un momento...", textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}
