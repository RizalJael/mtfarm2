import 'package:flutter/material.dart';
import '../../helpers/mortal_db.dart';
import '../../models/mortal_mdl.dart';
// import '../models/mortal_mdl.dart';
// import '../helpers/mortal_db.dart';
import 'mortal_edit.dart';

class MortalShow extends StatefulWidget {
  final int mortalId;

  const MortalShow({super.key, required this.mortalId});

  @override
  _MortalShowState createState() => _MortalShowState();
}

class _MortalShowState extends State<MortalShow> {
  final MortalDB mortalDB = MortalDB();
  Mortal? _mortal;

  @override
  void initState() {
    super.initState();
    _refreshMortalData();
  }

  void _refreshMortalData() async {
    final mortal = await mortalDB.getMortalById(widget.mortalId);
    setState(() {
      _mortal = mortal;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_mortal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Mortal')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mortal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MortalEdit(mortal: _mortal!),
                ),
              ).then((_) => _refreshMortalData());
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
            _buildDetailRow('Kode', _mortal!.kode),
            _buildDetailRow('Jenis', _mortal!.jenis ?? 'Tidak tersedia'),
            _buildDetailRow('Jenis Kelamin', _mortal!.jkel ?? 'Tidak tersedia'),
            _buildDetailRow('Tanggal', _mortal!.tgl),
            _buildDetailRow('Penyebab', _mortal!.penyebab),
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
              const Text('Apakah Anda yakin ingin menghapus data mortal ini?'),
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
                await mortalDB.deleteMortal(_mortal!.id!);
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
