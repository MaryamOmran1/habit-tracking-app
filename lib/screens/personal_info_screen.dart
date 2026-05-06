import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  
  double _age = 25;
  String _selectedCountry = 'United States';
  bool _isLoading = true;
  
  final List<String> _countries = [
    'United States', 'United Kingdom', 'Canada', 'Australia', 'Germany', 
    'France', 'Italy', 'Spain', 'Brazil', 'Mexico', 'India', 'China', 
    'Japan', 'South Korea', 'Saudi Arabia', 'Egypt', 'South Africa', 
    'Turkey', 'UAE', 'Kuwait', 'Bahrain', 'Qatar', 'Oman', 'Jordan', 
    'Lebanon', 'Morocco', 'Algeria', 'Tunisia', 'Libya'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _nameController.text = prefs.getString('user_name') ?? '';
        _usernameController.text = prefs.getString('user_username') ?? '';
        
        final ageValue = prefs.get('user_age');
        if (ageValue is double) {
          _age = ageValue;
        } else if (ageValue is int) {
          _age = ageValue.toDouble();
        } else if (ageValue is String && ageValue.isNotEmpty) {
          final numericPart = ageValue.split(' ').first;
          _age = double.tryParse(numericPart) ?? 25;
        } else {
          _age = 25;
        }
        
        _selectedCountry = prefs.getString('user_country') ?? 'United States';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData() async {
    if (_nameController.text.isEmpty) {
      _showToast('Please enter your name', Colors.orange);
      return;
    }
    if (_usernameController.text.isEmpty) {
      _showToast('Please enter your username', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text);
      await prefs.setString('user_username', _usernameController.text);
      await prefs.setDouble('user_age', _age);
      await prefs.setString('user_country', _selectedCountry);
      await prefs.setString('user_age_text', '${_age.toInt()} years old');
      
      _showToast('Profile updated successfully!', Colors.green);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      _showToast('Error saving profile', Colors.red);
      setState(() => _isLoading = false);
    }
  }

  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveUserData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade400, Colors.purple.shade400],
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 60, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Name', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Username', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
                      prefixIcon: const Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Age', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('18'),
                            Text('${_age.toInt()} years', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            const Text('100'),
                          ],
                        ),
                        Slider(
                          value: _age,
                          min: 18,
                          max: 100,
                          divisions: 82,
                          activeColor: Colors.blue,
                          onChanged: (value) => setState(() => _age = value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Country', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountry,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                        items: _countries.map((country) {
                          return DropdownMenuItem(value: country, child: Text(country));
                        }).toList(),
                        onChanged: (newValue) => setState(() => _selectedCountry = newValue!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}