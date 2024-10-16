import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/pages/add_page.dart';
import 'package:todo_app/pages/completed_page.dart';
import 'package:todo_app/providers/todo_provider.dart';

import '../models/todo.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> activeTodos =
        todos.where((todo) => todo.completed == false).toList();
    List<Todo> completedTodos =
        todos.where((todo) => todo.completed == true).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: activeTodos.length + 1,
        itemBuilder: (context, index) {
          if (activeTodos.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 300.0),
              child: Center(
                child: Text('Add tasks to get started!',
                    style: TextStyle(fontSize: 16)),
              ),
            );
          } else if (index == activeTodos.length) {
            if (completedTodos.isEmpty) {
              return Container();
            } else {
              return Center(
                  child: TextButton(
                child: const Text("Completed Todos"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CompletedPage()));
                },
              ));
            }
          } else {
            return Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => ref
                        .watch(todoProvider.notifier)
                        .deleteTodo(activeTodos[index].todoId),
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    icon: Icons.delete,
                  )
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => ref
                        .watch(todoProvider.notifier)
                        .completeTodo(activeTodos[index].todoId),
                    backgroundColor: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    icon: Icons.check,
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
                  title: Text(activeTodos[index].content),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddPage()));
        },
        tooltip: 'Add Task',
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
