import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/populasi_db.dart';
import '../../models/populasi_mdl.dart';
// import 'populasi_mdl.dart';
// import 'populasi_db.dart';

class PopulasiCreate extends StatefulWidget {
  const PopulasiCreate({super.key});

  @override
  _PopulasiCreateState createState() => _PopulasiCreateState();
}

class _PopulasiCreateState extends State<PopulasiCreate> {
  final _formKey = GlobalKey<FormState>();
  final PopulasiDB populasiDB = PopulasiDB();

  late String _tgl;
  late String _jenis;
  late String _jkel;
  late String _kode;
  String? _induk;
  late String _sumber;
  late String _asal;
  String? _keterangan;
  late String _status;

  final List<String> _jenisOptions = [
    'Sapi',
    'Kambing',
    'Domba'
  ]; // Sesuaikan dengan opsi yang Anda miliki
  final List<String> _jkelOptions = ['Jantan', 'Betina'];
  final List<String> _sumberOptions = ['Suplier', 'Kelahiran'];
  final List<String> _statusOptions = ['Aktif', 'Tidak Aktif'];

  @override
  void initState() {
    super.initState();
    _tgl = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _jenis = _jenisOptions[0];
    _jkel = _jkelOptions[0];
    _sumber = _sumberOptions[0];
    _status = _statusOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Populasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildDatePicker(),
              _buildDropdownField(
                  'Jenis', _jenisOptions, (value) => _jenis = value!),
              _buildDropdownField(
                  'Jenis Kelamin', _jkelOptions, (value) => _jkel = value!),
              _buildTextField('Kode', (value) => _kode = value!),
              _buildTextField('Induk', (value) => _induk = value,
                  required: false),
              _buildDropdownField(
                  'Sumber', _sumberOptions, (value) => _sumber = value!),
              _buildTextField('Asal', (value) => _asal = value!),
              _buildTextField('Keterangan', (value) => _keterangan = value,
                  required: false),
              _buildDropdownField(
                  'Status', _statusOptions, (value) => _status = value!),
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

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Expanded(child: Text('Tanggal')),
          TextButton(
            child: Text(_tgl),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
              );
              if (picked != null) {
                setState(() {
                  _tgl = DateFormat('yyyy-MM-dd').format(picked);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        value: options[0],
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved,
      {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon isi field ini';
                }
                return null;
              }
            : null,
        onSaved: onSaved,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPopulasi = Populasi(
        tgl: _tgl,
        jenis: _jenis,
        jkel: _jkel,
        kode: _kode,
        induk: _induk,
        sumber: _sumber,
        asal: _asal,
        keterangan: _keterangan,
        status: _status,
      );
      populasiDB.insertPopulasi(newPopulasi).then((_) {
        Navigator.pop(context);
      });
    }
  }
}
