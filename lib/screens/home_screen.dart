// home_screen.dart
import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'user_info_screen.dart';
import 'create_permission_screen.dart';
import 'entry_exit_info_screen.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _photoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPhotoUrl();
  }

  Future<void> _fetchPhotoUrl() async {
    final photoUrl = await UserService.fetchUserPhotoUrl();
    setState(() {
      _photoUrl = photoUrl;
      _isLoading = false;
    });
  }

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
          child: _isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_photoUrl != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(_photoUrl!),
                        radius: 50,
                      ),
                    SizedBox(height: 16.0),
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
