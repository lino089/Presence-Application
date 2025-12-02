import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            HeaderProfil(),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  kartuJadwal(
                    namaKelas: 'XI RPL 2', 
                    jamPelajaran: '7:15 - 8:45', 
                    status: '(Sedang Berlangsung)', 
                    isActive: true,
                  ),
                  kartuJadwal(
                    namaKelas: 'XI DKV 2', 
                    jamPelajaran: '10:45 - 11:30', 
                    status: 'Status : Menunggu', 
                    isActive: false,
                  ),
                  kartuJadwal(
                    namaKelas: 'XI TKJ 2', 
                    jamPelajaran: '12:30 - 14:00', 
                    status: 'Status : Menunggu', 
                    isActive: false,
                  ),
                  kartuJadwal(
                    namaKelas: 'XI AKL 2', 
                    jamPelajaran: '14:00 - 15:30', 
                    status: 'Status : Menunggu', 
                    isActive: false,
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        iconSize: 32,
        elevation: 15,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Home', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Jadwal', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Kelas', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Profil', 
          ),
        ]
      ),
    );
  }

  Widget HeaderProfil() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5) 
          )
        ]
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rossy Rahmadani',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Guru Rekayasa Perangkat Lunak',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                'Senin, 28 Oktober, 2025',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class kartuJadwal extends StatelessWidget {
  final String namaKelas, jamPelajaran, status;
  final bool isActive;
  const kartuJadwal({
    super.key,
    required this.namaKelas,
    required this.jamPelajaran,
    required this.status,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), 
          blurRadius: 10, 
          offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                namaKelas,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                status,
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.grey,
                  fontStyle: isActive ? FontStyle.italic : FontStyle.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Jam Pelajaran',
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          Text(
            jamPelajaran,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          if (isActive)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("Presensi Dimulai");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20)
                  ),
                ),
                child: Text(
                  'Mulai Presensi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          // if(!isActive)
        ],
      ),
    );
  }
}
