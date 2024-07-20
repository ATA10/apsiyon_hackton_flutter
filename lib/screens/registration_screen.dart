import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  File? _image;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveRegistration() {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final address = _addressController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || address.isEmpty) {
      Fluttertoast.showToast(
        msg: "Lütfen tüm alanları doldurunuz.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      final registrationData = {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      };

      final registrationJson = jsonEncode(registrationData);

      // JSON verisini burada kaydedin (dosyaya yazma, API'ye gönderme vs.)
      print("Kayıt verisi: $registrationJson");

      Fluttertoast.showToast(
        msg: "Kayıt başarılı!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
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
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? Icon(Icons.add_a_photo) : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'İsim - Soyisim',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Mail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRegistration,
                child: Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
