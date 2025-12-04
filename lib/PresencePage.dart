import 'package:flutter/material.dart';
import 'package:presensi_app/siswa.dart';

class Presencepage extends StatefulWidget {
  @override
  _HalamanPresensiState createState() => _HalamanPresensiState();
}

class _HalamanPresensiState extends State<Presencepage> {
  List<Siswa> listSiswa = List.from(daftarSiswaAwal);

  List<Siswa> listSiswaHadir = [];

  int totalSiswa = daftarSiswaAwal.length;
  int sudahPresensi = 0;

  void updateStatus(int index, String statusBaru) {
    setState(() {
      Siswa siswaYangDihapus = listSiswa[index];
      String statusLama = siswaYangDihapus.status;

      if (statusBaru == 'H') {
        bool nambahProgres = (statusLama == '');
        if (nambahProgres) {
          sudahPresensi++;
        }

        listSiswaHadir.add(siswaYangDihapus);

        listSiswa.removeAt(index);
      } else {
        if (statusLama == '') {
          sudahPresensi++;
        }
        listSiswa[index].status = statusBaru;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = totalSiswa == 0 ? 0 : sudahPresensi / totalSiswa;

    int jumlahHadir = totalSiswa - listSiswa.length;

    int jumlahSakit = listSiswa.where((siswa) => siswa.status == 'S').length;
    int jumlahIzin = listSiswa.where((siswa) => siswa.status == 'I').length;
    int jumlahAlpha = listSiswa.where((siswa) => siswa.status == 'A').length;

    int totalSiapKirim = jumlahHadir + jumlahSakit + jumlahAlpha + jumlahIzin;
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        toolbarHeight: 80,

        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,

        title: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "XI RPL 2",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Pemrograman Pengkat Bergerak",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.history, color: Colors.black),
                  onPressed: () {
                    _tampilkanModalHistory();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Progres Presensi ${(progressValue * 100).toInt()}%"),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blueAccent,
                      minHeight: 15,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: listSiswa.length,
              itemBuilder: (context, index) {
                final Siswa = listSiswa[index];
                return _buildCardSiswa(Siswa, index);
              },
            ),
          ),
          _buildBottomSummary(
            jumlahHadir,
            jumlahSakit,
            jumlahIzin,
            jumlahAlpha,
            totalSiapKirim,
          ),
        ],
      ),
    );
  }

  void _tampilkanModalHistory() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Riwayat Kehadiran (${listSiswaHadir.length})",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Klik tombol silang untuk membatalkan kehadiran",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Divider(),

                  Expanded(
                    child: listSiswaHadir.isEmpty
                        ? Center(child: Text("Belum ada siswa yang hadir"))
                        : ListView.builder(
                            itemCount: listSiswaHadir.length,
                            itemBuilder: (context, index) {
                              final siswa = listSiswaHadir[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    siswa.fotoProfile,
                                  ),
                                ),
                                title: Text(
                                  siswa.nama,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(siswa.nis),
                                trailing: IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      listSiswa.add(siswa);

                                      listSiswa.sort(
                                        (a, b) => a.nis.compareTo(b.nis),
                                      );

                                      listSiswaHadir.removeAt(index);

                                      sudahPresensi--;
                                    });

                                    setModalState(() {});

                                    if (listSiswaHadir.isEmpty)
                                      Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCardSiswa(Siswa siswa, int index) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                "${index + 1}.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 15),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(siswa.fotoProfile),
              ),

              SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      siswa.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Nis : ${siswa.nis}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        _buildTombolBulat('H', siswa.status, index),
                        SizedBox(width: 8),
                        _buildTombolBulat('S', siswa.status, index),
                        SizedBox(width: 8),
                        _buildTombolBulat('I', siswa.status, index),
                        SizedBox(width: 8),
                        _buildTombolBulat('A', siswa.status, index),
                        SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTombolBulat(String label, String StatusSaatIni, int index) {
    bool isSelected = label == StatusSaatIni;

    Color warnaAktif;
    if (label == 'H')
      warnaAktif = Colors.green;
    else if (label == 'S')
      warnaAktif = Colors.orange;
    else if (label == 'I')
      warnaAktif = Colors.blue;
    else
      warnaAktif = Colors.red;

    return InkWell(
      onTap: () {
        updateStatus(index, label);
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: isSelected ? warnaAktif : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? warnaAktif : Colors.grey),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummary(
    int hadir,
    int sakit,
    int izin,
    int alpha,
    int totalSiap,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Center(
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: _buildKotakStatus(
                          "Hadir",
                          hadir,
                          Colors.green.shade100,
                          Colors.green.shade600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildKotakStatus(
                          "Sakit",
                          sakit,
                          Colors.orange.shade100,
                          Colors.orange.shade600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildKotakStatus(
                          "Izin",
                          izin,
                          Colors.blue.shade100,
                          Colors.blue.shade600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildKotakStatus(
                          "Alpha",
                          alpha,
                          Colors.red.shade100,
                          Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _simulasiKirimData(hadir, sakit, izin, alpha);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Kirim Presensi ($totalSiap)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKotakStatus(
    String label,
    int count,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      width: 75,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Text(label, style: TextStyle(color: textColor, fontSize: 12)),
        ],
      ),
    );
  }

  void _simulasiKirimData(int h, int s, int i, int a) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Berhasil Terkirim"),
          content: Text(
            "Data telah disimpan.\n\n"
            "Hadir: $h\nSakit: $s\nIzin: $i\nAlpha: $a",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
