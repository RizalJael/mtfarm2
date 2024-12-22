import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/populasi_db.dart';
import '../../models/populasi_mdl.dart';
import 'populasi_show.dart';
import 'populasi_create.dart';
import 'populasi_edit.dart';

class PopulasiView extends StatefulWidget {
  const PopulasiView({super.key});

  @override
  _PopulasiViewState createState() => _PopulasiViewState();
}

class _PopulasiViewState extends State<PopulasiView> {
  final PopulasiDB populasiDB = PopulasiDB();
  List<Populasi> populasiList = [];
  List<Populasi> filteredPopulasiList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _refreshPopulasiList();
  }

  _refreshPopulasiList() async {
    List<Populasi> freshList = await populasiDB.getAllPopulasi();
    setState(() {
      populasiList = freshList;
      _filterPopulasi();
    });
  }

  void _filterPopulasi() {
    setState(() {
      filteredPopulasiList = populasiList.where((populasi) {
        return populasi.kode
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            populasi.jenis.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _filterPopulasi();
    });
  }

  void _deletePopulasi(int id) async {
    await populasiDB.deletePopulasi(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Populasi berhasil dihapus')),
    );
    _refreshPopulasiList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0961F6),
        title: const Text('Daftar Populasi',
            style: TextStyle(color: Colors.white)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari kode atau jenis',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: filteredPopulasiList.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          Populasi populasi = filteredPopulasiList[index];
          return ListTile(
            title: Text(populasi.kode),
            subtitle: Text('${populasi.tgl} - ${populasi.status}'),
            leading: Icon(
              Icons.pets,
              color: Colors.blue,
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (String result) {
                switch (result) {
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PopulasiEdit(populasi: populasi),
                      ),
                    ).then((_) => _refreshPopulasiList());
                    break;
                  case 'delete':
                    _deletePopulasi(populasi.id!);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Hapus'),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PopulasiShow(populasi: populasi),
                ),
              ).then((_) => _refreshPopulasiList());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PopulasiCreate(),
            ),
          ).then((_) => _refreshPopulasiList());
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Data', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0961F6),
      ),
    );
  }
}
