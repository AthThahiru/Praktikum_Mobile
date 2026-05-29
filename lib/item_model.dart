// ==========================================
// FILE: lib/item_model.dart
// ==========================================

class ItemModel {
  final int id;
  final String name;
  final String description;
  int quantity;
  final String category; // Menyimpan data kategori barang

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.category,
  });

  // Mengonversi data objek Dart ke bentuk Map (untuk SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'category': category,
    };
  }

  // Mengonversi data Map kembali ke bentuk objek Dart
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      category: map['category'] ?? 'Elektronik',
    );
  }
}