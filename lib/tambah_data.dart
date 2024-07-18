import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';

class TambahData extends StatefulWidget {
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  TextEditingController nikController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController umurController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController nohpController = TextEditingController();
  String? pinjamValue = '1500000';
  String? tempoValue = '1';
  TextEditingController angsuranController = TextEditingController();

  XFile? _imageFile; // Variabel untuk menyimpan file gambar yang dipilih

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImage(ImageSource source) async {
      XFile? pickedFile = await ImagePicker().pickImage(source: source);
      setState(() {
        _imageFile = pickedFile;
      });
    }

    Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
      try {
        // Ambil nama file gambar dari path
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Referensi ke Firebase Storage
        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(fileName);

        // Unggah file gambar
        await storageReference.putFile(File(_imageFile!.path));

        // Dapatkan URL download gambar
        String imageUrl = await storageReference.getDownloadURL();

        return imageUrl;
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
        return '';
      }
    }

    void addData() async {
      // Upload gambar terlebih dahulu
      String imageUrl =
          await _uploadImageToFirebaseStorage(File(_imageFile!.path));

      // Setelah gambar diunggah, tambahkan data ke Firestore
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('nasabah')
          .doc(nikController.text);

      Map<String, dynamic> nsb = {
        "nik": nikController.text,
        "nama": namaController.text,
        "umur": umurController.text,
        "alamat": alamatController.text,
        "nohp": nohpController.text,
        "pinjam": pinjamValue,
        "tempo": tempoValue,
        "angsuran": angsuranController.text,
        "photoUrl": imageUrl, // Simpan URL gambar di sini setelah diunggah
      };

      // Kirim data ke Firestore
      documentReference
          .set(nsb)
          .then((value) => print('${nikController.text} created'))
          .catchError((error) => print('Failed to add data: $error'));

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("ADD DATA"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Text(
              "Input Data Nasabah",
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: nikController,
              decoration: InputDecoration(
                labelText: "NIK",
              ),
            ),
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextFormField(
              controller: umurController,
              decoration: InputDecoration(labelText: "Umur"),
            ),
            TextFormField(
              controller: alamatController,
              decoration: InputDecoration(labelText: "Alamat"),
            ),
            TextFormField(
              controller: nohpController,
              decoration: InputDecoration(labelText: "No HP"),
            ),
            DropdownButtonFormField<String>(
              value: pinjamValue,
              onChanged: (String? newValue) {
                setState(() {
                  pinjamValue = newValue;
                });
              },
              decoration: InputDecoration(labelText: "Pinjam"),
              items: <String>['1500000', '3000000', '5000000', '10000000']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButtonFormField<String>(
              value: tempoValue,
              onChanged: (String? newValue) {
                setState(() {
                  tempoValue = newValue;
                });
              },
              decoration: InputDecoration(labelText: "Tempo Tahun"),
              items: <String>['1', '2', '3', '4', '5']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextFormField(
              controller: angsuranController,
              decoration: InputDecoration(labelText: "Angsuran Bulanan"),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _pickImage(ImageSource.gallery);
              },
              child: Container(
                color: Colors.grey[200],
                height: 150,
                child: _imageFile == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                    : Image.file(File(_imageFile!.path)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                addData();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
