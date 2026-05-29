import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_model.dart'; // Pastikan file item_model.dart kamu tetap ada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Multi-Category Inventory',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff6366f1),
          surface: const Color(0xfff8fafc),
        ),
      ),
      home: const CategoryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========================================
// 1. HALAMAN UTAMA: PILIHAN KATEGORI (FIXED SCROLL & FAB)
// ==========================================
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, dynamic>> _categories = [];
  final TextEditingController _catNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Ambil data kategori dari memori SharedPreferences
  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? catString = prefs.getString('categories_list');

    if (catString != null) {
      setState(() {
        _categories = List<Map<String, dynamic>>.from(json.decode(catString));
      });
    } else {
      // Data dummy awal
      setState(() {
        _categories = [
          {'name': 'Elektronik', 'code': 'E'},
          {'name': 'Pakaian', 'code': 'P'},
          {'name': 'Makanan', 'code': 'M'},
        ];
      });
      _saveCategories();
    }
  }

  // Simpan data kategori
  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('categories_list', json.encode(_categories));
  }

  // Tambah kategori baru dengan inisial otomatis
  void _addCategory() {
    if (_catNameController.text.isEmpty) return;

    final String name = _catNameController.text;
    final String code = name.trim().substring(0, 1).toUpperCase();

    setState(() {
      _categories.add({
        'name': name,
        'code': code,
      });
    });

    _saveCategories();
    _catNameController.clear();
    Navigator.pop(context);
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Tambah Kategori Baru', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: _catNameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Nama Kategori',
            hintText: 'Contoh: Olahraga, Buku, Otomotif',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _catNameController.clear();
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _addCategory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Kategori Inventaris', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      // Menggunakan Stack murni agar tombol "+ Kategori" mengambang bebas di atas ListView
      body: Stack(
        children: [
          // 1. Area List Kategori yang SEKARANG BISA DI-SCROLL LANCAR
          ListView.builder(
            itemCount: _categories.length,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), // Ditambah padding bawah biar tidak tertutup tombol
            itemBuilder: (context, index) {
              final cat = _categories[index];
              
              IconData iconData = Icons.category_rounded;
              if (cat['name'] == 'Elektronik') iconData = Icons.devices_rounded;
              if (cat['name'] == 'Pakaian') iconData = Icons.checkroom_rounded;
              if (cat['name'] == 'Makanan') iconData = Icons.fastfood_rounded;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(iconData, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(cat['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff1e293b))),
                  subtitle: Text('Kode Inventaris: ${cat['code']}1, ${cat['code']}2...', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemListPage(
                          categoryName: cat['name'],
                          categoryCode: cat['code'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          // 2. Tombol "+ Kategori" yang DIKUNCI di Kanan Bawah Layar Web
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: _showAddCategoryDialog,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _catNameController.dispose();
    super.dispose();
  }
}

// ==========================================
// 2. HALAMAN DAFTAR BARANG (PER KATEGORI)
// ==========================================
class ItemListPage extends StatefulWidget {
  final String categoryName;
  final String categoryCode;

  const ItemListPage({super.key, required this.categoryName, required this.categoryCode});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<ItemModel> _allItems = []; 
  List<ItemModel> _filteredItems = []; 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<ItemModel> _dummyItems = [
    ItemModel(id: 1, name: 'MacBook Pro', description: 'Apple M3, 16GB RAM', quantity: 5, category: 'Elektronik'),
    ItemModel(id: 2, name: 'Magic Mouse', description: 'Wireless Mouse', quantity: 0, category: 'Elektronik'),
    ItemModel(id: 3, name: 'Kemeja Flanel', description: 'Bahan katun ukuran L', quantity: 12, category: 'Pakaian'),
    ItemModel(id: 4, name: 'Chiki Balls', description: 'Rasa keju gurih', quantity: 20, category: 'Makanan'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsString = prefs.getString('items_list');

    if (itemsString != null) {
      final List<dynamic> itemsMap = json.decode(itemsString);
      setState(() {
        _allItems = itemsMap.map((item) => ItemModel.fromMap(item)).toList();
        _applyFilter();
      });
    } else {
      setState(() {
        _allItems = List.from(_dummyItems);
        _applyFilter();
      });
      await _saveData();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> itemsMap = _allItems.map((item) => item.toMap()).toList();
    final String itemsString = json.encode(itemsMap);
    await prefs.setString('items_list', itemsString);
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchCategory = item.category == widget.categoryName;
        final matchQuery = item.name.toLowerCase().contains(query) || item.description.toLowerCase().contains(query);
        return matchCategory && matchQuery;
      }).toList();
    });
  }

  int get _totalStokKategori {
    return _allItems
        .where((item) => item.category == widget.categoryName)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  void _addItem() {
    if (_nameController.text.isEmpty || _descController.text.isEmpty || _qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi!')),
      );
      return;
    }

    int newId = _allItems.isNotEmpty ? _allItems.last.id + 1 : 1;
    int inputQty = int.tryParse(_qtyController.text) ?? 1;

    final newItem = ItemModel(
      id: newId,
      name: _nameController.text,
      description: _descController.text,
      quantity: inputQty,
      category: widget.categoryName,
    );

    setState(() {
      _allItems.add(newItem);
      _nameController.clear();
      _descController.clear();
      _qtyController.clear();
      _applyFilter();
    });

    _saveData();
    Navigator.pop(context);
  }

  void _increaseQuantity(ItemModel item) {
    setState(() {
      item.quantity++;
    });
    _saveData();
  }

  void _decreaseQuantity(ItemModel item) {
    if (item.quantity > 0) {
      setState(() {
        item.quantity--;
      });
      _saveData();

      if (item.quantity == 0) {
        _showDeleteConfirmation(item);
      }
    }
  }

  void _showDeleteConfirmation(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item?'),
        content: Text('Stok ${item.name} sudah habis. Ingin menghapus barang ini dari daftar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem(item.id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(int id) async {
    final int deletedIndexGlobal = _allItems.indexWhere((item) => item.id == id);
    final ItemModel deletedItem = _allItems[deletedIndexGlobal];

    setState(() {
      _allItems.removeAt(deletedIndexGlobal);
      _applyFilter();
    });
    await _saveData();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedItem.name} berhasil dihapus'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'BATAL',
          textColor: Colors.yellow,
          onPressed: () {
            setState(() {
              _allItems.insert(deletedIndexGlobal, deletedItem);
              _applyFilter();
            });
            _saveData();
          },
        ),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Tambah ${widget.categoryName} Baru', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Item',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah awal (Stok)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _descController.clear();
                _qtyController.clear();
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Inventaris ${widget.categoryName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _applyFilter(),
                decoration: InputDecoration(
                  hintText: 'Cari di ${widget.categoryName.toLowerCase()}...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            _applyFilter();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Jenis Barang', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        Text('${_filteredItems.length} Item', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Stok', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        Text('$_totalStokKategori Pcs', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
            child: Text('Daftar Inventaris Aktif', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),

          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers_clear_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('Tidak ada item ditemukan', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final bool isHabis = item.quantity == 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: isHabis ? Colors.grey.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isHabis ? Colors.grey.shade200 : Colors.grey.shade100, width: 1),
                        ),
                        child: Opacity(
                          opacity: isHabis ? 0.6 : 1.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: isHabis 
                                    ? Colors.grey.shade200 
                                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.categoryCode}${index + 1}',
                                  style: TextStyle(
                                    color: isHabis ? Colors.grey : Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1e293b)),
                                ),
                                const SizedBox(width: 8),
                                if (isHabis)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                                    child: const Text('HABIS', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                  )
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 6.0),
                                  child: Text(item.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _decreaseQuantity(item),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                                        child: const Icon(Icons.remove, size: 16, color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                      child: Text(
                                        'Stok: ${item.quantity}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 13, 
                                          color: isHabis ? Colors.red : Colors.black87
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _increaseQuantity(item),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                                        child: const Icon(Icons.add, size: 16, color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            trailing: IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                                child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 20),
                              ),
                              onPressed: () => _deleteItem(item.id),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _qtyController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}