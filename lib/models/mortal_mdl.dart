class Mortal {
  int? id;
  String kode;
  String tgl;
  String penyebab;
  String? jenis; // Dari tabel populasi
  String? jkel; // Dari tabel populasi

  Mortal({
    this.id,
    required this.kode,
    required this.tgl,
    required this.penyebab,
    this.jenis,
    this.jkel,
  });

  // Konversi dari Map (biasanya dari database) ke objek Mortal
  factory Mortal.fromMap(Map<String, dynamic> map) {
    return Mortal(
      id: map['id'],
      kode: map['kode'],
      tgl: map['tgl'],
      penyebab: map['penyebab'],
      jenis: map['jenis'],
      jkel: map['jkel'],
    );
  }

  // Konversi dari objek Mortal ke Map (biasanya untuk menyimpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kode': kode,
      'tgl': tgl,
      'penyebab': penyebab,
      // Tidak perlu menyertakan jenis dan jkel karena itu berasal dari tabel populasi
    };
  }

  // Override toString untuk memudahkan debugging
  @override
  String toString() {
    return 'Mortal{id: $id, kode: $kode, tgl: $tgl, penyebab: $penyebab, jenis: $jenis, jkel: $jkel}';
  }
}
