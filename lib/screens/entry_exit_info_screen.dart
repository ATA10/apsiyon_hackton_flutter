import 'package:flutter/material.dart';
import '../services/permissions_service.dart';
import '../services/ip_adress.dart';

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
            FutureBuilder<List<Permission>>(
              future: fetchPermissions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final permissions = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: permissions.length,
                      itemBuilder: (context, index) {
                        final permission = permissions[index];
                        return ElevatedButton(
                          onPressed: () {
                            showPermissionDialog(context, permission);
                          },
                          child: Text('Permission ID: ${permission.id}'),
                        );
                      },
                    ),
                  );
                } else {
                  return Text('No permissions found');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showPermissionDialog(BuildContext context, Permission permission) {
    String imageUrl = '$ipAdres${permission.qrImageUrl}';
    print('QR Image URL: $imageUrl'); // Debugging line

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('İzin Detayları'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('İzin Atayan: ${permission.assignedById}'),
                Text('Apartman Adı: ${permission.apartmentId}'),
                Text('Başlangıç Tarih: ${permission.startDate}'),
                Text('Bitiş Tarih: ${permission.endDate}'),
                Image.network(
                  imageUrl,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    print('Failed to load image: $exception'); // Debugging line
                    return Text('Failed to load QR image');
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}