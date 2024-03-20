import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  late SharedPreferences prefs;

  Future getPrefs() async {
    prefs = await SharedPreferences.getInstance(); // Koneksi ke penyimpanan perangkat pengguna
    final int? counter = prefs.getInt('attendanceCount');
    return Text(
      '${counter}',
      style: TextStyle(fontSize: 60.0),
    );
  }

  Future getName() async {
    prefs = await SharedPreferences.getInstance(); // Koneksi ke penyimpanan perangkat pengguna
    final String? name = prefs.getString('name');
    return Text(
      name!,
      style: TextStyle(fontSize: 60.0),
    );
  }

  Future getDept() async {
    prefs = await SharedPreferences.getInstance(); // Koneksi ke penyimpanan perangkat pengguna
    final String? dept = prefs.getString('dept');
    return Text(
      dept!,
      style: TextStyle(fontSize: 60.0),
    );
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Jumlah Kehadiran: ',
                  style: TextStyle(fontSize: 30.0),
                ),
                FutureBuilder(
                  future: getPrefs(),
                  builder: (context, snapshot) {
                    return snapshot.data;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                FutureBuilder(
                  future: getName(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    }
                    return Text('Mohon masukkan nama.');
                  },
                ),
                FutureBuilder(
                  future: getDept(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    }
                    return Text('Mohon masukkan jurusan.');
                  },
                ),
              ],
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
