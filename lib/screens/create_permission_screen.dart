import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class CreatePermissionScreen extends StatefulWidget {
  @override
  _CreatePermissionScreenState createState() => _CreatePermissionScreenState();
}

class _CreatePermissionScreenState extends State<CreatePermissionScreen> {
  String _selectedPermissionType = 'QR oluştur';
  String _selectedEntryType = 'Durum';
  bool _showAdditionalFields = false;
  TextEditingController _additionalInfoController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _numberDate;
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Future<void> _pickNumberDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _numberDate = pickedDate;
      });
    }
  }

  Map<String, dynamic> _collectFormData() {
    // Değer girilmeyen alanları JSON'a yazmamak için null kontrolü yapıyoruz.
    final Map<String, dynamic> formData = {};

    if (_nameController.text.isNotEmpty) {
      formData['name'] = _nameController.text;
    }
    if (_phoneController.text.isNotEmpty) {
      formData['phone'] = _phoneController.text;
    }
    if (_emailController.text.isNotEmpty) {
      formData['email'] = _emailController.text;
    }
    formData['permissionType'] = _selectedPermissionType;
    if (_additionalInfoController.text.isNotEmpty) {
      formData['additionalInfo'] = _additionalInfoController.text;
    }
    formData['entryType'] = _selectedEntryType;

    if (_selectedEntryType == 'Sayılı') {
      if (_numberController.text.isNotEmpty) {
        formData['number'] = _numberController.text;
      }
      if (_numberDate != null) {
        formData['numberDate'] = _numberDate?.toIso8601String();
      }
    } else if (_selectedEntryType == 'Tarihli') {
      if (_startDate != null) {
        formData['startDate'] = _startDate?.toIso8601String();
      }
      if (_endDate != null) {
        formData['endDate'] = _endDate?.toIso8601String();
      }
    } else if (_selectedEntryType == 'Durum') {
      formData['durum'] = true;
    }

    if (_image != null) {
      formData['imagePath'] = _image?.path;
    }

    return formData;
  }

  void _saveData() {
    final formData = _collectFormData();
    final jsonData = jsonEncode(formData);
    print(jsonData);

    // Kayıt başarılı toast gösterimi
    Fluttertoast.showToast(
      msg: "Kayıt başarılı",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // JSON içeriği olan uyarı gösterimi
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kayıt Başarılı"),
          content: Text(jsonData),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // AlertDialog'u kapat
                Navigator.of(context).pop();  // Modal'ı kapat
                Navigator.pushReplacementNamed(context, '/home');  // Anasayfaya yönlendir
              },
              child: Text("Tamam"),
            ),
          ],
        );
      },
    ).then((_) {
      Navigator.pushReplacementNamed(context, '/home');  // Anasayfaya yönlendir
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                labelText: 'Ad-Soyad',
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
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: Text('QR oluştur'),
                  selected: _selectedPermissionType == 'QR oluştur',
                  onSelected: (selected) {
                    setState(() {
                      _selectedPermissionType = 'QR oluştur';
                      _showAdditionalFields = false;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('Fotograf'),
                  selected: _selectedPermissionType == 'Fotograf ile giriş',
                  onSelected: (selected) {
                    setState(() {
                      _selectedPermissionType = 'Fotograf ile giriş';
                      _showAdditionalFields = true;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('Mobil'),
                  selected: _selectedPermissionType == 'Mobil ile giriş',
                  onSelected: (selected) {
                    setState(() {
                      _selectedPermissionType = 'Mobil ile giriş';
                      _showAdditionalFields = true;
                    });
                  },
                ),
              ],
            ),
            if (_selectedPermissionType == 'Fotograf ile giriş')
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null ? Icon(Icons.add_a_photo) : null,
                      ),
                      if (_image != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.file(
                            _image!,
                            height: 100,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            if (_showAdditionalFields)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _additionalInfoController,
                  decoration: InputDecoration(
                    labelText: 'Giriş sayısı giriniz',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: Text('Durum'),
                  selected: _selectedEntryType == 'Durum',
                  onSelected: (selected) {
                    setState(() {
                      _selectedEntryType = 'Durum';
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('Tarihli'),
                  selected: _selectedEntryType == 'Tarihli',
                  onSelected: (selected) {
                    setState(() {
                      _selectedEntryType = 'Tarihli';
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('Sayılı'),
                  selected: _selectedEntryType == 'Sayılı',
                  onSelected: (selected) {
                    setState(() {
                      _selectedEntryType = 'Sayılı';
                    });
                  },
                ),
              ],
            ),
            if (_selectedEntryType == 'Sayılı')
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: _numberController,
                      decoration: InputDecoration(
                        labelText: 'Sayı giriniz',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () => _pickNumberDate(context),
                      child: Text(_numberDate == null ? 'Sayı geçerlilik tarihi seç' : 'Geçerlilik tarihi: ${_numberDate?.toLocal().toString().split(' ')[0]}'),
                    ),
                  ],
                ),
              ),
            if (_selectedEntryType == 'Tarihli')
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => _pickDate(context, true),
                      child: Text(_startDate == null ? 'Başlangıç tarihi seç' : 'Başlangıç tarihi: ${_startDate?.toLocal().toString().split(' ')[0]}'),
                    ),
                    TextButton(
                      onPressed: () => _pickDate(context, false),
                      child: Text(_endDate == null ? 'Bitiş tarihi seç' : 'Bitiş tarihi: ${_endDate?.toLocal().toString().split(' ')[0]}'),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
