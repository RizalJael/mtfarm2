class Potong {
  int? id;
  String kode;
  String tgl;
  double bobot;
  String tujuan;
  String? jenis; // Dari tabel populasi
  String? jkel; // Dari tabel populasi

  Potong({
    this.id,
    required this.kode,
    required this.tgl,
    required this.bobot,
    required this.tujuan,
    this.jenis,
    this.jkel,
  });

  // Konversi dari Map (biasanya dari database) ke objek Potong
  factory Potong.fromMap(Map<String, dynamic> map) {
    return Potong(
      id: map['id'],
      kode: map['kode'],
      tgl: map['tgl'],
      bobot:
          map['bobot'] is int ? (map['bobot'] as int).toDouble() : map['bobot'],
      tujuan: map['tujuan'],
      jenis: map['jenis'],
      jkel: map['jkel'],
    );
  }

  // Konversi dari objek Potong ke Map (biasanya untuk menyimpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kode': kode,
      'tgl': tgl,
      'bobot': bobot,
      'tujuan': tujuan,
      // Tidak perlu menyertakan jenis dan jkel karena itu berasal dari tabel populasi
    };
  }

  // Override toString untuk memudahkan debugging
  @override
  String toString() {
    return 'Potong{id: $id, kode: $kode, tgl: $tgl, bobot: $bobot, tujuan: $tujuan, jenis: $jenis, jkel: $jkel}';
  }
}
