import 'package:flutter/material.dart';
import '../models/habit.dart';

class DetailScreen extends StatefulWidget {
  final Habit item;
  final String itemType;

  const DetailScreen({
    super.key,
    required this.item,
    this.itemType = 'habit',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _habitNameController = TextEditingController();
  Color _selectedColor = Colors.amber;
  List<String> _customHabits = [];

  @override
  void initState() {
    super.initState();
    _habitNameController.text = widget.item.title;
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.itemType == 'habit' ? 'Configure Habits' : 'Meditation Details',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _selectedColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.item.isCompleted ? Icons.check_circle : Icons.fitness_center,
                  color: _selectedColor,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.item.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.item.category,
                style: TextStyle(color: Colors.purple.shade700),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  widget.item.duration,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.item.description,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Configure Habits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Habit Name:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _habitNameController,
              decoration: InputDecoration(
                hintText: 'Enter habit name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Colour:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildColorOption(Colors.red, 'Red'),
                const SizedBox(width: 12),
                _buildColorOption(Colors.amber, 'Amber'),
                const SizedBox(width: 12),
                _buildColorOption(Colors.green, 'Green'),
                const SizedBox(width: 12),
                _buildColorOption(Colors.blue, 'Blue'),
                const SizedBox(width: 12),
                _buildColorOption(Colors.purple, 'Purple'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _addCustomHabit,
              icon: const Icon(Icons.add),
              label: const Text('Add Habits'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            if (_customHabits.isNotEmpty) ...[
              const Text(
                'Your Habits:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._customHabits.map((habit) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _selectedColor.withOpacity(0.2),
                        child: Icon(Icons.check, color: _selectedColor),
                      ),
                      title: Text(habit),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeCustomHabit(habit),
                      ),
                    ),
                  )),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to List'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, String name) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: _selectedColor == color ? Border.all(color: Colors.black, width: 3) : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: _selectedColor == color ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _addCustomHabit() {
    if (_habitNameController.text.isNotEmpty) {
      setState(() {
        _customHabits.add(_habitNameController.text);
        _habitNameController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ "${_habitNameController.text}" added!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
    }
  }

  void _removeCustomHabit(String habit) {
    setState(() => _customHabits.remove(habit));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🗑️ "$habit" removed')),
    );
  }
}q