import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page2.dart';
import 'page3.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _index = 0; // Indeks halaman 0, 1
  var _pages = [
    Page1(),
    Page2(),
    Page3(),
  ];

  static final LatLng universityLatLng = LatLng(
    37.3047, // Garis lintang
    127.9226, // Garis bujur
  );

  // Buat penanda lokasi perusahaan
  static final Marker marker = Marker(
    markerId: MarkerId('perusahaan'),
    position: universityLatLng,
  );

  // Menampilkan radius lokasi saat ini
  static final Circle circle = Circle(
    circleId: CircleId('circlePeriksaSekolah'),
    center: universityLatLng, // Posisi pusat lingkaran
    fillColor: Colors.blue.withOpacity(0.5), // Warna lingkaran
    radius: 200, // Radius lingkaran (dalam meter)
    strokeColor: Colors.blue, // Warna pinggiran lingkaran
    strokeWidth: 1, // Ketebalan lingkaran
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          currentIndex: _index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Beranda',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Informasi Siswa',
              icon: Icon(Icons.account_circle),
            ),
            BottomNavigationBarItem(
              label: 'Informasi Masuk Sekolah',
              icon: Icon(Icons.account_circle),
            ),
          ]),
    );
  }
}

class Page1 extends StatefulWidget {
  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  var counter;

  Future initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('jumlahKehadiran') == null)
      await prefs.setInt('jumlahKehadiran', 0);
    counter = prefs.getInt('jumlahKehadiran');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == 'Izin lokasi telah diberikan.') {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _HomeScreenState.universityLatLng,
                      zoom: 16,
                    ),
                    markers: Set.from([_HomeScreenState.marker]),
                    circles: Set.from([_HomeScreenState.circle]),
                    myLocationEnabled: true,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timelapse_outlined,
                        color: Colors.blue,
                        size: 50.0,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final curPosition = await Geolocator.getCurrentPosition(); 

                          final distance = Geolocator.distanceBetween(
                            curPosition.latitude,
                            curPosition.longitude,
                            _HomeScreenState.universityLatLng.latitude,
                            _HomeScreenState.universityLatLng.longitude,
                          );

                          bool bisaCek = distance < 200; 

                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('Masuk Sekolah'),

                                  content: Text(
                                    bisaCek ? 'Apakah Anda akan masuk sekolah?' : "Lokasi tidak dapat digunakan untuk masuk.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Batal'),
                                    ),

                                    if (bisaCek)
                                      TextButton(
                                        onPressed: () async {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          Navigator.of(context).pop(true);
                                          setState(() {
                                            counter++;
                                            prefs.setInt('jumlahKehadiran', counter);
                                          });
                                        },
                                        child: Text('Masuk Sekolah'),
                                      ),
                                  ],
                                );
                              }
                          );
                        },
                        child: Text('Masuk Sekolah!'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Center(
            child: Text(
              snapshot.data.toString(),
            ),
          );
        }
    );
  }
}

AppBar renderAppBar() {
  return AppBar(
    centerTitle: true,
    title: Text(
      'Hari Ini Masuk Sekolah',
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.white,
  );
}

Future<String> checkPermission() async {
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationEnabled) { 
    return 'Aktifkan layanan lokasi.';
  }

  LocationPermission checkedPermission = await Geolocator.checkPermission();

  if (checkedPermission == LocationPermission.denied) { 

    checkedPermission = await Geolocator.requestPermission();

    if (checkedPermission == LocationPermission.denied) {
      return 'Izinkan aplikasi mengakses lokasi.';
    }
  }

  if (checkedPermission == LocationPermission.deniedForever) {
    return 'Izinkan aplikasi mengakses lokasi melalui pengaturan.';
  }

  return 'Izin lokasi telah diberikan.';
}
