import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/populasi_db.dart';
import '../../helpers/potong_db.dart';
import '../../models/populasi_mdl.dart';
import '../../models/potong_mdl.dart';

class PotongCreate extends StatefulWidget {
  const PotongCreate({super.key});

  @override
  _PotongCreateState createState() => _PotongCreateState();
}

class _PotongCreateState extends State<PotongCreate> {
  final _formKey = GlobalKey<FormState>();
  final PotongDB potongDB = PotongDB();
  final PopulasiDB populasiDB = PopulasiDB();

  String? _selectedKode;
  late String _tgl;
  late double _bobot;
  late String _tujuan;

  List<Populasi> _populasiList = [];

  final TextEditingController _tglController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tgl = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _tglController.text = _tgl;
    _loadPopulasi();
  }

  void _loadPopulasi() async {
    List<Populasi> populasiList = await populasiDB.getAllPopulasi();
    setState(() {
      _populasiList = populasiList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Potong'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedKode,
                decoration: const InputDecoration(labelText: 'Kode Populasi'),
                items: _populasiList.map((populasi) {
                  return DropdownMenuItem<String>(
                    value: populasi.kode,
                    child: Text('${populasi.kode} - ${populasi.jenis}'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKode = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon pilih kode populasi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tglController,
                decoration: const InputDecoration(labelText: 'Tanggal'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      _tglController.text = formattedDate;
                      _tgl = formattedDate;
                    });
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Bobot (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi bobot';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Mohon masukkan angka yang valid';
                  }
                  return null;
                },
                onSaved: (value) => _bobot = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tujuan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi tujuan';
                  }
                  return null;
                },
                onSaved: (value) => _tujuan = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPotong = Potong(
        kode: _selectedKode!,
        tgl: _tgl,
        bobot: _bobot,
        tujuan: _tujuan,
      );
      potongDB.insertPotong(newPotong).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data potong berhasil ditambahkan')),
        );
        Navigator.pop(context);
      });
    }
  }
}
