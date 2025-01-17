import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/providers/todo_provider.dart';

import '../models/todo.dart';

class CompletedPage extends ConsumerWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> completedTodos =
        todos.where((todo) => todo.completed == true).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: completedTodos.length,
        itemBuilder: (context, index) {
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => ref
                      .watch(todoProvider.notifier)
                      .deleteTodo(completedTodos[index].todoId),
                  backgroundColor: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  icon: Icons.delete,
                )
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                title: Text(completedTodos[index].content),
              ),
            ),
          );
        },
      ),
    );
  }
}
