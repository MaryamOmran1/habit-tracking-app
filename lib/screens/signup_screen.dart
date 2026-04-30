import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  DateTime? _selectedAge;
  String _selectedCountry = 'United States';
  String? _selectedAgeText;

  final List<String> _allHabits = [
    'Wake Up Early', 'Workout', 'Drink Water', 'Meditate',
    'Read a Book', 'Practice Gratitude', 'Sleep 8 Hours',
    'Eat Healthy', 'Journal', 'Walk 10,000 Steps'
  ];

  final List<bool> _selectedHabits = List.filled(10, false);

  final List<String> _countries = [
    'United States', 'United Kingdom', 'Canada', 'Australia', 'Germany', 'France',
    'Italy', 'Spain', 'Brazil', 'Mexico', 'India', 'China', 'Japan', 'South Korea',
    'Saudi Arabia', 'Egypt', 'South Africa', 'Turkey', 'UAE', 'Kuwait', 'Bahrain',
    'Qatar', 'Oman', 'Jordan', 'Lebanon', 'Morocco', 'Algeria', 'Tunisia', 'Libya'
  ];

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_username', _usernameController.text);
    await prefs.setString('user_email', _emailController.text);
    await prefs.setString('user_password', _passwordController.text);
    await prefs.setString('user_age', _selectedAgeText ?? '');
    await prefs.setString('user_country', _selectedCountry);
    
    List<String> selectedHabitsList = [];
    for (int i = 0; i < _allHabits.length; i++) {
      if (_selectedHabits[i]) selectedHabitsList.add(_allHabits[i]);
    }
    await prefs.setStringList('user_habits', selectedHabitsList);
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty || _usernameController.text.isEmpty ||
        _emailController.text.isEmpty || _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty || _selectedAge == null) {
      _showErrorDialog('Please fill in all fields.');
      return false;
    }
    if (!_emailController.text.contains('@')) {
      _showErrorDialog('Please enter a valid email address.');
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showErrorDialog('Password must be at least 6 characters long.');
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match.');
      return false;
    }
    if (!_selectedHabits.any((selected) => selected)) {
      _showErrorDialog('Please select at least one habit.');
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Account created successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectAge() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedAge = picked;
        _selectedAgeText = '${DateTime.now().year - picked.year} years old';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: _selectAge,
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(text: _selectedAgeText ?? 'Select Age'),
                  decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()),
              items: _countries.map((country) => DropdownMenuItem(value: country, child: Text(country))).toList(),
              onChanged: (value) => setState(() => _selectedCountry = value!),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Your Habits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                ),
                itemCount: _allHabits.length,
                itemBuilder: (context, index) => CheckboxListTile(
                  title: Text(_allHabits[index], style: const TextStyle(fontSize: 12)),
                  value: _selectedHabits[index],
                  onChanged: (value) => setState(() => _selectedHabits[index] = value!),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (_validateForm()) {
                  await _saveUserData();
                  _showSuccessDialog();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}