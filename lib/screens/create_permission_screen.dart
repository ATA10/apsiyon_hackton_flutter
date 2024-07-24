import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../services/token_manager.dart';

class CreatePermissionScreen extends StatefulWidget {
  @override
  _CreatePermissionScreenState createState() => _CreatePermissionScreenState();
}

class _CreatePermissionScreenState extends State<CreatePermissionScreen> {
  String _selectedPermissionType = '';
  String _selectedEntryType = '';
  bool _showAdditionalFields = false;
  TextEditingController _additionalInfoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _image;
  String? _selectedApartmentId;
  List<Map<String, dynamic>> _apartments = [];

  @override
  void initState() {
    super.initState();
    _fetchApartments();
  }

  Future<void> _fetchApartments() async {
    String? token = await TokenManager().getToken();

    if (token == null) {
      Fluttertoast.showToast(
        msg: "Token alınamadı",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/apartments'),
      headers: {
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _apartments = data.map((apartment) => {
          'id': apartment['apartment_id'],
          'name': apartment['apartment_name'],
        }).toList();
      });
    } else {
      Fluttertoast.showToast(
        msg: "Failed to fetch apartments",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

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

  Map<String, dynamic> _collectFormData() {
    final Map<String, dynamic> formData = {};

    if (_emailController.text.isNotEmpty) {
      formData['user_id'] = _emailController.text;
    }
    if (_selectedApartmentId != null) {
      formData['apartment_id'] = _selectedApartmentId;
    } else {
      formData['apartment_id'] = '1'; // Fallback apartment_id
    }
    if (_selectedEntryType == 'Tarih') {
      if (_startDate != null) {
        formData['start_date'] = _startDate?.toIso8601String();
      }
      if (_endDate != null) {
        formData['end_date'] = _endDate?.toIso8601String();
      }
    }
    if (_image != null) {
      formData['imagePath'] = _image?.path;
    }

    return formData;
  }

  Future<void> _saveData() async {
    String? token = await TokenManager().getToken();

    if (token == null) {
      Fluttertoast.showToast(
        msg: "Token alınamadı",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    final formData = _collectFormData();
    final jsonData = jsonEncode(formData);
    print("Form Data: $jsonData");

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/user/permission/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Kayıt başarılı",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Kayıt Başarılı"),
            content: Text(response.body),
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
    } else {
      Fluttertoast.showToast(
        msg: "Kayıt başarısız: ${response.body}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
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
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'İzin verilecek E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedApartmentId,
              items: _apartments.map((apartment) {
                return DropdownMenuItem<String>(
                  value: apartment['id'].toString(),
                  child: Text(apartment['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedApartmentId = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Giriş yeri',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
              ],
            ),
            if (_selectedPermissionType == 'Fotograf ile giriş')
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Fotograf Yükle"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text("Kameradan Çek"),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text("Galeriden Seç"),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? Icon(Icons.add_a_photo) : null,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  labelPadding: EdgeInsets.symmetric(horizontal: 23),
                  label: Text('Tarih Aralığı Seçin: '),
                  selected: _selectedEntryType == 'Tarih',
                  onSelected: (selected) {
                    setState(() {
                      _selectedEntryType = 'Tarih';
                    });
                  },
                ),
              ],
            ),
            if (_selectedEntryType == 'Tarih')
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
