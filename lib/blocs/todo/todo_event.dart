import 'package:equatable/equatable.dart';
import '../../models/todo.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;

  AddTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class UpdateTodo extends TodoEvent {
  final Todo todo;

  UpdateTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final int id;

  DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteMultipleTodos extends TodoEvent {
  final List<int> ids;

  DeleteMultipleTodos(this.ids);

  @override
  List<Object?> get props => [ids];
}
