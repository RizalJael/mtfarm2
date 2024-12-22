import 'package:flutter/material.dart';
import '../../helpers/potong_db.dart';
import '../../models/potong_mdl.dart';

import 'potong_show.dart';
import 'potong_create.dart';

class PotongView extends StatefulWidget {
  const PotongView({super.key});

  @override
  _PotongViewState createState() => _PotongViewState();
}

class _PotongViewState extends State<PotongView> {
  final PotongDB potongDB = PotongDB();
  List<Potong> potongList = [];

  @override
  void initState() {
    super.initState();
    _refreshPotongList();
  }

  _refreshPotongList() async {
    List<Potong> freshList = await potongDB.getAllPotongWithPopulasi();
    setState(() {
      potongList = freshList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Potong'),
      ),
      body: ListView.builder(
        itemCount: potongList.length,
        itemBuilder: (context, index) {
          Potong potong = potongList[index];
          return Card(
            child: ListTile(
              title: Text('Kode: ${potong.kode} - ${potong.jenis ?? ""}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tanggal: ${potong.tgl}'),
                  Text('Bobot: ${potong.bobot} kg'),
                  Text('Tujuan: ${potong.tujuan}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmationDialog(potong),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PotongShow(potongId: potong.id!),
                  ),
                ).then((_) => _refreshPotongList());
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PotongCreate()),
          ).then((_) => _refreshPotongList());
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(Potong potong) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content:
              const Text('Apakah Anda yakin ingin menghapus data potong ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () async {
                await potongDB.deletePotong(potong.id!);
                Navigator.of(context).pop();
                _refreshPotongList();
              },
            ),
          ],
        );
      },
    );
  }
}
