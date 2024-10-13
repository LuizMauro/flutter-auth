import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/todo/todo_bloc.dart';
import '../../blocs/todo/todo_event.dart';
import '../../repositories/todo_repository.dart';
import '../../models/todo.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo? todo;
  final TodoRepository todoRepository;

  const TodoDetailScreen({
    super.key,
    this.todo,
    required this.todoRepository,
  });

  @override
  _TodoDetailScreenState createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String? _description;

  @override
  void initState() {
    super.initState();
    _title = widget.todo?.title ?? '';
    _description = widget.todo?.description;
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final todo = Todo(
        id: widget.todo?.id,
        title: _title,
        description: _description,
        isCompleted: widget.todo?.isCompleted ?? false,
      );

      final todoBloc = context.read<TodoBloc>();

      if (widget.todo == null) {
        todoBloc.add(AddTodo(todo));
      } else {
        todoBloc.add(UpdateTodo(todo));
      }

      Navigator.pop(context);
    }
  }

  void _deleteTodo() {
    if (widget.todo != null) {
      final todoBloc = context.read<TodoBloc>();
      todoBloc.add(DeleteTodo(widget.todo!.id!));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTodo,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _saveTodo,
                child: Text(isEditing ? 'Atualizar' : 'Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
