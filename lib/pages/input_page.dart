// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'result_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Anak-anak',
    'Remaja',
    'Dewasa',
  ];

  String _selectedGender = 'Laki-laki';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFF5F7FA),
        elevation: 0,
        title: Text(
          "Kalkulator BMI",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // NAMA
                TextFormField(
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon isi data ini';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama...',
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: Color(0xFF3B82F6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFF3B82F6),
                        width: 2,
                      ),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),

                SizedBox(height: 24),

                // BERAT
                TextFormField(
                  controller: _weightController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon isi data ini';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    labelText: 'Berat Badan',
                    hintText: 'Contoh: 65',
                    suffixText: 'kg',
                    prefixIcon: Icon(
                      Icons.monitor_weight_outlined,
                      color: Color(0xFF3B82F6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFF3B82F6),
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),

                SizedBox(height: 24),

                // TINGGI
                TextFormField(
                  controller: _heightController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon isi data ini';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    labelText: 'Tinggi Badan',
                    hintText: 'Contoh: 170',
                    suffixText: 'cm',
                    prefixIcon: Icon(
                      Icons.height_rounded,
                      color: Color(0xFF3B82F6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),

                SizedBox(height: 24),

                // KATEGORI
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon isi data ini';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    prefixIcon: Icon(
                      Icons.category_rounded,
                      color: Color(0xFF3B82F6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFF3B82F6),
                        width: 2,
                      ),
                    ),
                  ),
                  hint: Text('Pilih kategori...'),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),

                SizedBox(height: 32),

                // JENIS KELAMIN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jenis Kelamin',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        // LAKI-LAKI
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = 'Laki-laki';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: _selectedGender == 'Laki-laki'
                                    ? Color(0xFF3B82F6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _selectedGender == 'Laki-laki'
                                      ? Color(0xFF3B82F6)
                                      : Colors.black12,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.male,
                                    size: 36,
                                    color: _selectedGender == 'Laki-laki'
                                        ? Colors.white
                                        : Colors.blue,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Laki-laki',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _selectedGender == 'Laki-laki'
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 16),

                        // PEREMPUAN
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = 'Perempuan';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: _selectedGender == 'Perempuan'
                                    ? Color(0xFFFF6B9D)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _selectedGender == 'Perempuan'
                                      ? Color(0xFFFF6B9D)
                                      : Colors.black12,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.female,
                                    size: 36,
                                    color: _selectedGender == 'Perempuan'
                                        ? Colors.white
                                        : Colors.pink,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Perempuan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _selectedGender == 'Perempuan'
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 40),

                // BUTTON
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final nama = _nameController.text;

                      final berat = double.parse(
                        _weightController.text,
                      );

                      final tinggi = double.parse(
                            _heightController.text,
                          ) /
                          100;

                      final bmi = berat / (tinggi * tinggi);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            nama: nama,
                            bmi: bmi,
                            gender: _selectedGender,
                            kategori: _selectedCategory!,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: const [
                          Color(0xFF3B82F6),
                          Color(0xFF60A5FA),
                        ],
                      ),
                    ),
                    width: double.infinity,
                    height: 55,
                    child: Center(
                      child: Text(
                        "Hitung",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  "Stay healthy ✨",
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
