import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../widgets/habit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';
  List<Habit> todoHabits = [];
  List<Habit> doneHabits = [];

  final List<Habit> meditationList = [
    Habit(
      id: '1',
      title: 'Mindful Breathing',
      description: 'Focus on your breath and maintain a steady rhythm to clear your mind and reduce stress.',
      category: 'calmness',
      duration: '10 minutes',
    ),
    Habit(
      id: '2',
      title: 'Body Scan Meditation',
      description: 'Gradually bring awareness to each part of your body, releasing tension and promoting relaxation.',
      category: 'relaxation',
      duration: '15 minutes',
    ),
    Habit(
      id: '3',
      title: 'Loving-Kindness',
      description: 'Cultivate feelings of compassion and love toward yourself and others.',
      category: 'compassion',
      duration: '12 minutes',
    ),
    Habit(
      id: '4',
      title: 'Walking Meditation',
      description: 'Practice mindfulness while walking, focusing on each step and breath.',
      category: 'mindfulness',
      duration: '20 minutes',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadHabits();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('user_name') ?? 'Guest';
    });
  }

  void _loadHabits() {
    todoHabits = [
      Habit(
        id: '1',
        title: 'Morning Workout',
        description: 'Complete 30 minutes of exercise',
        category: 'Health',
        duration: '30 min',
        isCompleted: false,
      ),
      Habit(
        id: '2',
        title: 'Read a Book',
        description: 'Read 20 pages of any book',
        category: 'Learning',
        duration: '20 min',
        isCompleted: false,
      ),
      Habit(
        id: '3',
        title: 'Meditate',
        description: 'Practice mindfulness for 10 minutes',
        category: 'Wellness',
        duration: '10 min',
        isCompleted: false,
      ),
    ];

    doneHabits = [
      Habit(
        id: '4',
        title: 'Drink Water',
        description: 'Drank 8 glasses of water',
        category: 'Health',
        duration: 'All day',
        isCompleted: true,
      ),
    ];
  }

  void _toggleHabitStatus(Habit habit, bool isInTodo) {
    setState(() {
      if (isInTodo) {
        todoHabits.remove(habit);
        doneHabits.add(habit.copyWith(isCompleted: true));
      } else {
        doneHabits.remove(habit);
        todoHabits.add(habit.copyWith(isCompleted: false));
      }
    });
    _showSnackBar(habit.title, !isInTodo);
  }

  void _showSnackBar(String title, bool isCompleted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCompleted ? '✅ $title completed!' : '🔄 $title moved back to To Do'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddHabitDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Habit Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  todoHabits.add(Habit(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    description: descController.text.isEmpty ? 'New habit added' : descController.text,
                    category: 'Custom',
                    duration: '10 min',
                    isCompleted: false,
                  ));
                });
                Navigator.pop(context);
                _showSnackBar(titleController.text, false);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Habitt',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade400, Colors.purple.shade300],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello $username!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find your perfect meditation and track your habits',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Popular Meditations', Icons.local_fire_department),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: meditationList.length,
                itemBuilder: (context, index) {
                  final meditation = meditationList[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.self_improvement, color: Colors.purple.shade700),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meditation.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        meditation.category,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.purple.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              meditation.description,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text(
                                  meditation.duration,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    _showSnackBar(meditation.title, true);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text('Start', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('To Do', Icons.pending_actions),
            todoHabits.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'Use the + button to create some habits!',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: todoHabits.length,
                    itemBuilder: (context, index) {
                      return HabitCard(
                        habit: todoHabits[index],
                        onToggle: () => _toggleHabitStatus(todoHabits[index], true),
                      );
                    },
                  ),
            const SizedBox(height: 16),
            if (doneHabits.isNotEmpty) ...[
              _buildSectionHeader('Done', Icons.check_circle, color: Colors.green),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: doneHabits.length,
                itemBuilder: (context, index) {
                  return HabitCard(
                    habit: doneHabits[index],
                    onToggle: () => _toggleHabitStatus(doneHabits[index], false),
                  );
                },
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {Color color = Colors.blue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.purple.shade500],
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                Text(
                  username,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('Habit Tracker', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.self_improvement),
            title: const Text('Meditations'),
            onTap: () {
              Navigator.pop(context);
              _showSnackBar('Meditations', false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text('Statistics'),
            onTap: () {
              Navigator.pop(context);
              _showSnackBar('Statistics', false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showSnackBar('Settings', false);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
