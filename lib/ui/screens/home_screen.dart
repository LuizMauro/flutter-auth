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

class HomeScreen extends StatefulWidget {
  final TodoRepository todoRepository;

  const HomeScreen({super.key, required this.todoRepository});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthenticationBloc authBloc;
  late TodoBloc todoBloc;

  final Map<int, bool> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    todoBloc = BlocProvider.of<TodoBloc>(context);
  }

  void _onItemSelect(int id) {
    setState(() {
      if (_selectedItems.containsKey(id)) {
        _selectedItems.remove(id);
      } else {
        _selectedItems[id] = true;
      }
    });
  }

  void _deleteSelectedItems() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Deletar ${_selectedItems.length} tarefa(s)?'),
          content: const Text('Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final selectedIds = _selectedItems.keys.toList();

      todoBloc.add(DeleteMultipleTodos(selectedIds));

      setState(() {
        _selectedItems.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedItems.isEmpty
            ? 'Lista de Tarefas'
            : '${_selectedItems.length} selecionada(s)'),
        actions: [
          if (_selectedItems.isEmpty)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authBloc.add(LoggedOut());
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedItems,
            ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('Nenhuma tarefa encontrada.'));
            }
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                final isSelected = _selectedItems.containsKey(todo.id);

                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (bool? selected) {
                      _onItemSelect(todo.id!);
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(todo.description ?? ''),
                  trailing: IconButton(
                    icon: Icon(
                      todo.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: todo.isCompleted ? Colors.green : null,
                    ),
                    onPressed: () {
                      final updatedTodo = Todo(
                        id: todo.id,
                        title: todo.title,
                        description: todo.description,
                        isCompleted: !todo.isCompleted,
                      );
                      todoBloc.add(UpdateTodo(updatedTodo));
                    },
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.grey[300],
                  onTap: () {
                    if (_selectedItems.isNotEmpty) {
                      _onItemSelect(todo.id!);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoDetailScreen(
                            todo: todo,
                            todoRepository: widget.todoRepository,
                          ),
                        ),
                      );
                    }
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
      floatingActionButton: _selectedItems.isEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoDetailScreen(
                      todoRepository: widget.todoRepository,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
