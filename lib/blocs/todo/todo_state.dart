import 'package:equatable/equatable.dart';
import '../../models/todo.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodosLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;

  TodosLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

class TodosError extends TodoState {
  final String error;

  TodosError(this.error);

  @override
  List<Object?> get props => [error];
}
