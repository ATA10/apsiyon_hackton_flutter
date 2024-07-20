import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  DateTime? _startDate;
  DateTime? _endDate;
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
              decoration: InputDecoration(
                labelText: 'Ad-Soyad',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Telefon',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
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
                    labelText: 'Ek Bilgiler',
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
                child: TextField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Numara girin',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            if (_selectedEntryType == 'Tarihli')
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _pickDate(context, true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _startDate == null
                              ? 'Başlangıç Tarihi'
                              : _startDate!.toLocal().toString().split(' ')[0],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _pickDate(context, false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _endDate == null
                              ? 'Bitiş Tarihi'
                              : _endDate!.toLocal().toString().split(' ')[0],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Kaydet işlemleri
              },
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
