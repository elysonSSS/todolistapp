import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolistapp/model/todo_model.dart';
import 'package:todolistapp/services/database_services.dart';
import 'package:todolistapp/widgets/colors.dart';

class PendingWidget extends StatefulWidget {
  const PendingWidget({super.key});

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;
  final DatabaseServices _databaseService = DatabaseServices();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
        stream: _databaseService.todos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Todo> todos = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                final DateTime dt = todo.timeStamp.toDate();
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: getRandomColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Slidable(
                    key: ValueKey(todo.id),
                    startActionPane:
                        ActionPane(motion: const DrawerMotion(), children: [
                      SlidableAction(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: "Editar",
                          onPressed: (context) {
                            _showTaskDialog(context, todo: todo);
                          }),
                      SlidableAction(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: "Deletar",
                          onPressed: (context) async {
                            await _databaseService.deleteTodoTask(todo.id);
                          })
                    ]),
                    endActionPane:
                        ActionPane(motion: const DrawerMotion(), children: [
                      SlidableAction(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.done,
                          label: "Pronta!",
                          onPressed: (context) {
                            _databaseService.updateTodoStatus(todo.id, true);
                          })
                    ]),
                    child: ListTile(
                      title: Text(todo.title,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(todo.description),
                      trailing: Text(
                        '${dt.day}/${dt.month}/${dt.year}\n${dt.hour}:${dt.minute}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white60,
              ),
            );
          }
        });
  }

  void _showTaskDialog(BuildContext context, {Todo? todo}) {
    final TextEditingController _titleController =
        TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: todo?.description);
    final DatabaseServices _databaseService = DatabaseServices();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            todo == null ? "Adicionar tarefa" : "Editar tarefa",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    cursorColor: Colors.black,
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Titulo",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    cursorColor: Colors.black,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descriçao",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (todo == null) {
                  await _databaseService.addTodoTask(
                      _titleController.text, _descriptionController.text);
                } else {
                  await _databaseService.updateTodo(todo.id,
                      _titleController.text, _descriptionController.text);
                }
                Navigator.pop(context);
              },
              child: Text(todo == null ? "Adicionar" : "Atualizar"),
            ),
          ],
        );
      },
    );
  }
}