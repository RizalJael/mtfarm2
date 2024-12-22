import 'package:flutter/material.dart';
import '../../helpers/mortal_db.dart';
import '../../models/mortal_mdl.dart';
// import '../helpers/mortal_db.dart';
// import '../models/mortal_mdl.dart';
import 'mortal_show.dart';
import 'mortal_create.dart';

class MortalView extends StatefulWidget {
  const MortalView({super.key});

  @override
  _MortalViewState createState() => _MortalViewState();
}

class _MortalViewState extends State<MortalView> {
  final MortalDB mortalDB = MortalDB();
  List<Mortal> mortalList = [];

  @override
  void initState() {
    super.initState();
    _refreshMortalList();
  }

  _refreshMortalList() async {
    List<Mortal> freshList = await mortalDB.getAllMortal();
    setState(() {
      mortalList = freshList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mortal'),
      ),
      body: ListView.builder(
        itemCount: mortalList.length,
        itemBuilder: (context, index) {
          Mortal mortal = mortalList[index];
          return ListTile(
            title: Text('Kode: ${mortal.kode}'),
            subtitle:
                Text('Tanggal: ${mortal.tgl} - Penyebab: ${mortal.penyebab}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmationDialog(mortal),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MortalShow(mortalId: mortal.id!),
                ),
              ).then((_) => _refreshMortalList());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MortalCreate()),
          ).then((_) => _refreshMortalList());
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(Mortal mortal) {
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
                await mortalDB.deleteMortal(mortal.id!);
                Navigator.of(context).pop();
                _refreshMortalList();
              },
            ),
          ],
        );
      },
    );
  }
}
