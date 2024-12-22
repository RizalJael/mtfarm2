import 'package:flutter/material.dart';
import '../../helpers/populasi_db.dart';
import '../../models/populasi_mdl.dart';
// import 'populasi_mdl.dart';
// import 'populasi_db.dart';
import 'populasi_edit.dart';

class PopulasiShow extends StatefulWidget {
  final Populasi populasi;

  const PopulasiShow({super.key, required this.populasi});

  @override
  _PopulasiShowState createState() => _PopulasiShowState();
}

class _PopulasiShowState extends State<PopulasiShow> {
  late Populasi _populasi;
  final PopulasiDB populasiDB = PopulasiDB();

  @override
  void initState() {
    super.initState();
    _populasi = widget.populasi;
  }

  void _refreshPopulasi() async {
    final updatedPopulasi = await populasiDB.getPopulasiByKode(_populasi.kode);
    if (updatedPopulasi != null) {
      setState(() {
        _populasi = updatedPopulasi;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Populasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PopulasiEdit(populasi: _populasi),
                ),
              ).then((_) => _refreshPopulasi());
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
            _buildDetailRow('Kode', _populasi.kode),
            _buildDetailRow('Tanggal', _populasi.tgl),
            _buildDetailRow('Jenis', _populasi.jenis),
            _buildDetailRow('Jenis Kelamin', _populasi.jkel),
            _buildDetailRow('Induk', _populasi.induk ?? 'Tidak ada'),
            _buildDetailRow('Sumber', _populasi.sumber),
            _buildDetailRow('Asal', _populasi.asal),
            _buildDetailRow('Keterangan', _populasi.keterangan ?? 'Tidak ada'),
            _buildDetailRow('Status', _populasi.status),
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
              const Text('Apakah Anda yakin ingin menghapus populasi ini?'),
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
                await populasiDB.deletePopulasi(_populasi.id!);
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
