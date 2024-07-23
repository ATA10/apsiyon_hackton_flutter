import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'user_info_screen.dart';
import 'create_permission_screen.dart';
import 'entry_exit_info_screen.dart';

// Misafir anasayfa
class HomeScreenGuest extends StatelessWidget {
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Anasayfa Misafir'),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => UserInfoScreen(),
                  );
                },
                child: Text('Bilgileri Güncelle'),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => EntryExitInfoScreen(),
                  );
                },
                child: Text('Giriş-Çıkış Bilgileri'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sakin sayfası
class HomeScreen extends StatelessWidget {
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => UserInfoScreen(),
                  );
                },
                child: Text('Bilgileri Güncelle'),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => CreatePermissionScreen(),
                  );
                },
                child: Text('Giriş İzni Oluştur'),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => EntryExitInfoScreen(),
                  );
                },
                child: Text('Giriş-Çıkış Bilgileri'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
