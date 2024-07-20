import 'package:flutter/material.dart';

class EntryExitInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Giriş-Çıkış bilgilerini gösteren widget'lar
            Text('Giriş-Çıkış Bilgileri Modal'),
          ],
        ),
      ),
    );
  }
}
