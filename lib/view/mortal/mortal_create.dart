import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/mortal_db.dart';
import '../../helpers/populasi_db.dart';
import '../../models/mortal_mdl.dart';
import '../../models/populasi_mdl.dart';

class MortalCreate extends StatefulWidget {
  const MortalCreate({super.key});

  @override
  _MortalCreateState createState() => _MortalCreateState();
}

class _MortalCreateState extends State<MortalCreate> {
  final _formKey = GlobalKey<FormState>();
  final MortalDB mortalDB = MortalDB();
  final PopulasiDB populasiDB = PopulasiDB();

  String? _selectedKode;
  late String _tgl;
  late String _penyebab;

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
        title: const Text('Tambah Data Mortal'),
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
                decoration: const InputDecoration(labelText: 'Penyebab'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi penyebab';
                  }
                  return null;
                },
                onSaved: (value) => _penyebab = value!,
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
      final newMortal = Mortal(
        kode: _selectedKode!,
        tgl: _tgl,
        penyebab: _penyebab,
      );
      mortalDB.insertMortal(newMortal).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data mortal berhasil ditambahkan')),
        );
        Navigator.pop(context);
      });
    }
  }
}
