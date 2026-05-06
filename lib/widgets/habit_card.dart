import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: habit.isCompleted ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: habit.isCompleted ? Colors.green.shade100 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    habit.isCompleted ? Icons.check_circle : Icons.fitness_center,
                    color: habit.isCompleted ? Colors.green : Colors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                          color: habit.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            habit.duration,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              habit.category,
                              style: TextStyle(fontSize: 10, color: Colors.purple.shade700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        habit.isCompleted ? Icons.undo : Icons.check_circle_outline,
                        color: habit.isCompleted ? Colors.orange : Colors.green,
                      ),
                      onPressed: onToggle,
                    ),
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: onEdit,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}