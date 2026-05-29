// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:bmi/utils/theme.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String nama, gender, kategori;
  final double bmi;

  const ResultPage({
    required this.nama,
    required this.bmi,
    required this.gender,
    required this.kategori,
    super.key,
  });

  String _getKategori() {
    if (bmi < 18.5) return 'Kurus';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return "Obesitas";
  }

  Color _getKategoriColor() {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25.0) return Colors.green;
    if (bmi < 30.0) return Colors.orange;
    return Colors.red;
  }

  double _getPointerPosition() {
    if (bmi < 18.5) {
      return (bmi / 18.5) * 0.25;
    } else if (bmi < 25) {
      return 0.25 + ((bmi - 18.5) / (25 - 18.5)) * 0.25;
    } else if (bmi < 30) {
      return 0.50 + ((bmi - 25) / (30 - 25)) * 0.25;
    } else {
      return 0.75 + ((bmi - 30) / 10) * 0.25;
    }
  }

  String _getMessage() {
    if (bmi < 18.5) {
      return "Berat badan kamu masih kurang";
    } else if (bmi < 25) {
      return "Berat badan kamu ideal";
    } else if (bmi < 30) {
      return "Mulai jaga pola makan ya";
    } else {
      return "Disarankan olahraga rutin";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F7FA),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Hasil BMI",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          color: Colors.black87,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 40),

                // ICON HEALTH
                CircleAvatar(
                  radius: 45,
                  backgroundColor: _getKategoriColor().withOpacity(0.15),
                  child: Icon(
                    Icons.accessibility_new_rounded,
                    size: bmi < 18.5
                        ? 42
                        : bmi < 25
                            ? 48
                            : bmi < 30
                                ? 54
                                : 60,
                    color: _getKategoriColor(),
                  ),
                ),

                SizedBox(height: 24),

                // CARD RESULT
                AnimatedContainer(
                  duration: Duration(microseconds: 700),
                  curve: Curves.easeOut,
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        nama,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "$gender • $kategori",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 24),

                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          bmi.toStringAsFixed(1),
                          key: ValueKey(bmi),
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: _getKategoriColor(),
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      Text(
                        _getKategori(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _getKategoriColor(),
                        ),
                      ),

                      SizedBox(height: 30),

                      // BMI INDICATOR
                      BmiIndicator(
                        value: _getPointerPosition(),
                        color: _getKategoriColor(),
                      ),

                      SizedBox(height: 24),

                      Text(
                        _getMessage(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                // BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                        "Hitung Ulang",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

class BmiIndicator extends StatelessWidget {
  final double value;
  final Color color;

  const BmiIndicator({
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        return Column(
          children: [
            SizedBox(height: 20),

            Stack(
              clipBehavior: Clip.none,
              children: [
                // BAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 14,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 14,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 14,
                          color: Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 14,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

                // POINTER
                Positioned(
                  top: -18,
                  left: (width * value).clamp(0.0, width - 24),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 32,
                    color: color,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // LABEL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Kurus",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Normal",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Over",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Obes",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
