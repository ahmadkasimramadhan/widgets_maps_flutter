import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  late SharedPreferences prefs;

  final _formKey = GlobalKey<FormState>(); // Kunci untuk mendapatkan status formulir

  final _nameController = TextEditingController(); // Objek kontroler untuk nama
  final _deptController = TextEditingController(); // Objek kontroler untuk jurusan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(5.0),
              child: Form(
                key: _formKey, // Mengatur kunci formulir
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nama', // Tampilan placeholder untuk nama
                      ),
                      controller: _nameController, // Menghubungkan kontroler nama
                      keyboardType: TextInputType.text, // Hanya menerima input teks
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Silakan masukkan nama';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Jurusan', // Tampilan placeholder untuk jurusan
                      ),
                      controller: _deptController,
                      keyboardType: TextInputType.text, // Hanya menerima input teks
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Silakan masukkan jurusan';
                        }
                        return null;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            prefs = await SharedPreferences.getInstance();
                            prefs.setString('name', _nameController.text.trim()); // Menyimpan nama ke penyimpanan perangkat
                            prefs.setString('dept', _deptController.text.trim()); // Menyimpan jurusan ke penyimpanan perangkat
                          }
                        },
                        child: Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Kebebasan / Kebenaran / Kreativitas',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}