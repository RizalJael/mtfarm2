import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/populasi_db.dart';
import '../../helpers/potong_db.dart';
import '../../models/populasi_mdl.dart';
import '../../models/potong_mdl.dart';

class PotongEdit extends StatefulWidget {
  final Potong potong;

  const PotongEdit({super.key, required this.potong});

  @override
  _PotongEditState createState() => _PotongEditState();
}

class _PotongEditState extends State<PotongEdit> {
  final _formKey = GlobalKey<FormState>();
  final PotongDB potongDB = PotongDB();
  final PopulasiDB populasiDB = PopulasiDB();

  late String _selectedKode;
  late String _tgl;
  late double _bobot;
  late String _tujuan;

  List<Populasi> _populasiList = [];

  final TextEditingController _tglController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedKode = widget.potong.kode;
    _tgl = widget.potong.tgl;
    _bobot = widget.potong.bobot;
    _tujuan = widget.potong.tujuan;
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
        title: const Text('Edit Data Potong'),
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
                    _selectedKode = newValue!;
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
                    initialDate: DateTime.parse(_tgl),
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
                initialValue: _bobot.toString(),
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
                initialValue: _tujuan,
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
                child: Text('Simpan Perubahan'),
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
      final updatedPotong = Potong(
        id: widget.potong.id,
        kode: _selectedKode,
        tgl: _tgl,
        bobot: _bobot,
        tujuan: _tujuan,
      );
      potongDB.updatePotong(updatedPotong).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data potong berhasil diperbarui')),
        );
        Navigator.pop(context);
      });
    }
  }
}