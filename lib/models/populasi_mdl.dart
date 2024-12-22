class Populasi {
  int? id;
  String tgl;
  String jenis;
  String jkel;
  String kode;
  String? induk;
  String sumber;
  String asal;
  String? keterangan;
  String status;

  Populasi({
    this.id,
    required this.tgl,
    required this.jenis,
    required this.jkel,
    required this.kode,
    this.induk,
    required this.sumber,
    required this.asal,
    this.keterangan,
    required this.status,
  });

  // Mengubah objek Populasi menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tgl': tgl,
      'jenis': jenis,
      'jkel': jkel,
      'kode': kode,
      'induk': induk,
      'sumber': sumber,
      'asal': asal,
      'keterangan': keterangan,
      'status': status,
    };
  }

  // Membuat objek Populasi dari Map
  factory Populasi.fromMap(Map<String, dynamic> map) {
    return Populasi(
      id: map['id'],
      tgl: map['tgl'],
      jenis: map['jenis'],
      jkel: map['jkel'],
      kode: map['kode'],
      induk: map['induk'],
      sumber: map['sumber'],
      asal: map['asal'],
      keterangan: map['keterangan'],
      status: map['status'],
    );
  }

  // Override toString untuk memudahkan debugging
  @override
  String toString() {
    return 'Populasi{id: $id, tgl: $tgl, jenis: $jenis, jkel: $jkel, kode: $kode, induk: $induk, sumber: $sumber, asal: $asal, keterangan: $keterangan, status: $status}';
  }
}
