import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = false;
  List<String> selectedHabits = [];
  List<String> selectedTimes = [];
  List<String> availableHabits = [];
  final List<String> timeSlots = ['Morning', 'Afternoon', 'Evening'];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _requestNotificationPermission();
  }

  void _requestNotificationPermission() {
    if (html.Notification.permission != 'granted') {
      html.Notification.requestPermission();
    }
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      selectedHabits = prefs.getStringList('notificationHabits') ?? [];
      selectedTimes = prefs.getStringList('notificationTimes') ?? [];
      availableHabits = prefs.getStringList('user_habits') ?? [
        'Morning Workout',
        'Read a Book',
        'Meditate',
        'Drink Water',
        'Eat Healthy',
        'Walk 10,000 Steps',
      ];
    } catch (e) {
      print('Error loading notification settings: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', notificationsEnabled);
      await prefs.setStringList('notificationHabits', selectedHabits);
      await prefs.setStringList('notificationTimes', selectedTimes);
    } catch (e) {
      print('Error saving notification settings: $e');
    }
  }

  void _sendTestNotification() {
    if (!notificationsEnabled) {
      _showSnackBar('Please enable notifications first', Colors.orange);
      return;
    }

    if (html.Notification.permission != 'granted') {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification('Habitt Reminder', body: 'Time to check your habits! Stay productive today! 💪');
          _showSnackBar('Test notification sent!', Colors.green);
        } else {
          _showSnackBar('Notification permission denied', Colors.red);
        }
      });
    } else {
      html.Notification('Habitt Reminder', body: 'Time to check your habits! Stay productive today! 💪');
      _showSnackBar('Test notification sent!', Colors.green);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading notification settings...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enable Notifications Switch
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Enable Notifications',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        notificationsEnabled
                            ? 'You will receive habit reminders'
                            : 'Turn on to receive notifications',
                        style: TextStyle(
                          color: notificationsEnabled ? Colors.green : Colors.grey,
                        ),
                      ),
                      value: notificationsEnabled,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          notificationsEnabled = value;
                        });
                        _saveNotificationSettings();
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Select Habits Section
                  if (notificationsEnabled) ...[
                    const Text(
                      'Select Habits for Notification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableHabits.map((habit) {
                          final isSelected = selectedHabits.contains(habit);
                          return FilterChip(
                            label: Text(habit),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedHabits.add(habit);
                                } else {
                                  selectedHabits.remove(habit);
                                }
                              });
                              _saveNotificationSettings();
                            },
                            selectedColor: Colors.blue.shade100,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected ? Colors.blue : Colors.grey.shade400,
                              width: 1.5,
                            ),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.blue.shade700 : Colors.black87,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Select Times Section
                    const Text(
                      'Select Times for Notification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: timeSlots.map((time) {
                          final isSelected = selectedTimes.contains(time);
                          IconData? timeIcon;
                          Color timeColor = isSelected ? Colors.blue : Colors.grey.shade600;
                          
                          switch (time) {
                            case 'Morning':
                              timeIcon = Icons.wb_sunny;
                              break;
                            case 'Afternoon':
                              timeIcon = Icons.sunny;
                              break;
                            case 'Evening':
                              timeIcon = Icons.nightlight_round;
                              break;
                          }
                          
                          return FilterChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(timeIcon, size: 16, color: timeColor),
                                const SizedBox(width: 6),
                                Text(time),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedTimes.add(time);
                                } else {
                                  selectedTimes.remove(time);
                                }
                              });
                              _saveNotificationSettings();
                            },
                            selectedColor: Colors.blue.shade100,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected ? Colors.blue : Colors.grey.shade400,
                              width: 1.5,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Test Notification Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _sendTestNotification,
                        icon: const Icon(Icons.notifications_active),
                        label: const Text('Send Test Notification'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Notifications will be sent at your selected times for the habits you choose. Make sure to allow browser notifications.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}