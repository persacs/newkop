import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class EditData extends StatefulWidget {
  final String? nik;
  final String? nama;
  final String? umur;
  final String? alamat;
  final String? nohp;
  final String? pinjam;
  final String? tempo;
  final String? angsuran;

  EditData(
      {this.nik,
      this.nama,
      this.umur,
      this.alamat,
      this.nohp,
      this.pinjam,
      this.tempo,
      this.angsuran});

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController nikController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController umurController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController nohpController = TextEditingController();
  TextEditingController pinjamController = TextEditingController();
  TextEditingController tempoController = TextEditingController();
  TextEditingController angsuranController = TextEditingController();

  void editData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('nasabah').doc(widget.nik);

    Map<String, dynamic> nsb = {
      "nik": widget.nik,
      "nama": namaController.text,
      "umur": umurController.text,
      "alamat": alamatController.text,
      "nohp": nohpController.text,
      "pinjam": pinjamController.text,
      "tempo": tempoController.text,
      "angsuran": angsuranController.text
    };

    // update data to Firebase
    documentReference
        .update(nsb)
        .whenComplete(() => print('${widget.nik} updated'));
  }

  void deleteData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('nasabah').doc(widget.nik);

    // delete data from Firebase
    documentReference
        .delete()
        .whenComplete(() => print('${widget.nik} deleted'));
  }

  void konfirmasi() {
    AlertDialog alertDialog = AlertDialog(
      content: Text("Apakah anda yakin akan menghapus data '${widget.nama}'?"),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.red, // Use backgroundColor instead of primary
          ),
          child: Text(
            "OK DELETE!",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            deleteData();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.green, // Use backgroundColor instead of primary
          ),
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    nikController = TextEditingController(text: widget.nik);
    namaController = TextEditingController(text: widget.nama);
    umurController = TextEditingController(text: widget.umur);
    alamatController = TextEditingController(text: widget.alamat);
    nohpController = TextEditingController(text: widget.nohp);
    pinjamController = TextEditingController(text: widget.pinjam);
    tempoController = TextEditingController(text: widget.tempo);
    angsuranController = TextEditingController(text: widget.angsuran);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EDIT DATA"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Text(
              "Ubah Data Nasabah",
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 40),
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
            TextFormField(
              controller: pinjamController,
              decoration: InputDecoration(labelText: "Pinjam"),
            ),
            TextFormField(
              controller: tempoController,
              decoration: InputDecoration(labelText: "Tempo"),
            ),
            TextFormField(
              controller: angsuranController,
              decoration: InputDecoration(labelText: "Angsuran"),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange, // Use backgroundColor instead of primary
                  ),
                  onPressed: () {
                    editData();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text("Ubah"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Use backgroundColor instead of primary
                  ),
                  onPressed: () {
                    konfirmasi();
                  },
                  child: Text("Hapus"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
