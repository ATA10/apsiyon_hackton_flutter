import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/user/UserDataManager.dart';
import '../services/user/user_data.dart';
import 'registration_screen.dart';
import 'home_screen.dart';
import '../services/token_manager.dart';
import '../services/ip_adress.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isResident = true;

  get ip_adres => ipAdres;

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('Kullanıcı adı ve şifre gerekli.');
      return;
    }

    String url = "$ip_adres/user/login";
    var data = {"email": username, "password": password};

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        var loginResponse = json.decode(response.body);

        if (loginResponse['token'] != null) {
          TokenManager().setToken(loginResponse['token']);
          UserData userData = UserData.fromJson(loginResponse['user']);
          UserDataManager.setUserData(userData);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => _isResident ? HomeScreen() : HomeScreenGuest()),
          );
        } else {
          _showSnackBar('Kullanıcı adı veya şifre hatalı');
        }
      } else {
        _showSnackBar('Giriş yapılamadı');
      }
    } catch (e) {
      _showSnackBar('Bir hata oluştu: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apsiyon Hackton'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAppIcon(),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _usernameController,
                  label: 'Kullanıcı İsim',
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Şifre',
                  obscureText: true,
                ),
                SizedBox(height: 20),
                _buildResidentSwitch(),
                SizedBox(height: 20),
                _buildLoginButton(),
                SizedBox(height: 20),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: Image.asset('assets/icons/app_icon.png'),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildResidentSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Sakin'),
        Switch(
          value: !_isResident,
          onChanged: (value) {
            setState(() {
              _isResident = !value;
            });
          },
        ),
        Text('Misafir'),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      child: Text('Giriş'),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => RegistrationScreen(),
        );
      },
      child: Text('Kayıt Ol'),
    );
  }
}
