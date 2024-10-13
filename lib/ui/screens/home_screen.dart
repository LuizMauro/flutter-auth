import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_event.dart';
import '../../blocs/todo/todo_bloc.dart';
import '../../blocs/todo/todo_event.dart';
import '../../blocs/todo/todo_state.dart';
import '../../repositories/todo_repository.dart';
import '../../models/todo.dart';
import 'todo_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final TodoRepository todoRepository;

  const HomeScreen({super.key, required this.todoRepository});

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final TodoBloc todoBloc = BlocProvider.of<TodoBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authBloc.add(LoggedOut());
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description ?? ''),
                  trailing: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      final updatedTodo = Todo(
                        id: todo.id,
                        title: todo.title,
                        description: todo.description,
                        isCompleted: value ?? false,
                      );
                      todoBloc.add(UpdateTodo(updatedTodo));
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoDetailScreen(
                          todo: todo,
                          todoRepository: todoRepository,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is TodosError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('Nenhuma tarefa encontrada.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoDetailScreen(
                todoRepository: todoRepository,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
