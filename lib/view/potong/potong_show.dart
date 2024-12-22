import 'package:flutter/material.dart';
import '../../helpers/potong_db.dart';
import '../../models/potong_mdl.dart';

import 'potong_edit.dart';

class PotongShow extends StatefulWidget {
  final int potongId;

  const PotongShow({super.key, required this.potongId});

  @override
  _PotongShowState createState() => _PotongShowState();
}

class _PotongShowState extends State<PotongShow> {
  final PotongDB potongDB = PotongDB();
  Potong? _potong;

  @override
  void initState() {
    super.initState();
    _refreshPotongData();
  }

  void _refreshPotongData() async {
    final potong = await potongDB.getPotongByIdWithPopulasi(widget.potongId);
    setState(() {
      _potong = potong;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_potong == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Potong')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Potong'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PotongEdit(potong: _potong!),
                ),
              ).then((_) => _refreshPotongData());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Kode', _potong!.kode),
            _buildDetailRow('Jenis', _potong!.jenis ?? 'Tidak tersedia'),
            _buildDetailRow('Jenis Kelamin', _potong!.jkel ?? 'Tidak tersedia'),
            _buildDetailRow('Tanggal', _potong!.tgl),
            _buildDetailRow('Bobot', '${_potong!.bobot} kg'),
            _buildDetailRow('Tujuan', _potong!.tujuan),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
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
                await potongDB.deletePotong(_potong!.id!);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to list view
              },
            ),
          ],
        );
      },
    );
  }
}
