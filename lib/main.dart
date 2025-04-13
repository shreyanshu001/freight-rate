import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const FreightRatesApp());
}

class FreightRatesApp extends StatelessWidget {
  const FreightRatesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freight Rates',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      home: const FreightSearchScreen(),
    );
  }
}

class FreightSearchScreen extends StatefulWidget {
  const FreightSearchScreen({super.key});

  @override
  State<FreightSearchScreen> createState() => _FreightSearchScreenState();
}

class _FreightSearchScreenState extends State<FreightSearchScreen> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _cutOffDateController = TextEditingController();
  final TextEditingController _boxesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String selectedShipmentType = 'FCL';
  String selectedContainerSize = '40\' Standard';

  bool includeNearbyOrigin = false;
  bool includeNearbyDestination = false;

  @override
  void initState() {
    super.initState();
    fetchUniversityData();
  }

  Future<void> fetchUniversityData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _originController.text = "no data found";
        _destinationController.text = "no data found";
      });
      final response = await http.get(
          Uri.parse('http://universities.hipolabs.com/search?name=middle'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _originController.text = data[0]['name'];
            _destinationController.text =
                data.length > 1 ? data[1]['name'] : data[0]['name'];
          });
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _cutOffDateController.dispose();
    _boxesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search the best Freight Rates',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFCCEDC),
                        foregroundColor: Colors.pink[800],
                        elevation: 0,
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('History'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: true,
                            onChanged: (value) {},
                            visualDensity: VisualDensity.compact,
                          ),
                          const Text('Origin',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _originController,
                        decoration: const InputDecoration(
                          isDense: true,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: includeNearbyOrigin,
                              onChanged: (value) {
                                setState(() {
                                  includeNearbyOrigin = value ?? false;
                                });
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Include nearby origin ports',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Radio(
                            value: false,
                            groupValue: true,
                            onChanged: (value) {},
                            visualDensity: VisualDensity.compact,
                          ),
                          const Text('Destination',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _destinationController,
                        decoration: const InputDecoration(
                          isDense: true,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: includeNearbyDestination,
                              onChanged: (value) {
                                setState(() {
                                  includeNearbyDestination = value ?? false;
                                });
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Include nearby destination ports',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Commodity',
                                isDense: true,
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _cutOffDateController,
                              decoration: const InputDecoration(
                                labelText: 'Cut Off Date',
                                isDense: true,
                                suffixIcon:
                                    Icon(Icons.calendar_today, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Text('Shipment Type:',
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: selectedShipmentType == 'FCL',
                              activeColor: Colors.indigo,
                              onChanged: (value) {
                                if (value == true) {
                                  setState(() {
                                    selectedShipmentType = 'FCL';
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('FCL'),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: selectedShipmentType == 'LCL',
                              onChanged: (value) {
                                if (value == true) {
                                  setState(() {
                                    selectedShipmentType = 'LCL';
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('LCL'),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Container Size',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedContainerSize,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: const [
                                  DropdownMenuItem(
                                      value: '40\' Standard',
                                      child: Text('40\' Standard')),
                                  DropdownMenuItem(
                                      value: '20\' Standard',
                                      child: Text('20\' Standard')),
                                  DropdownMenuItem(
                                      value: '40\' High Cube',
                                      child: Text('40\' High Cube')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedContainerSize = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _boxesController,
                              decoration: const InputDecoration(
                                labelText: 'No of Boxes',
                                isDense: true,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _weightController,
                              decoration: const InputDecoration(
                                labelText: 'Weight (kg)',
                                isDense: true,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Text('Container Internal Dimensions:'),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildDimensionRow('Length', '39.6ft'),
                                const SizedBox(height: 8),
                                _buildDimensionRow('Width', '7.7ft'),
                                const SizedBox(height: 8),
                                _buildDimensionRow('Height', '7.8ft'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.search, size: 18),
                          label: const Text('Search'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade100,
                            foregroundColor: Colors.indigo.shade800,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
