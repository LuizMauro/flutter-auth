import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../../repositories/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodosLoading());
    try {
      final todos = await _todoRepository.getTodos();
      emit(TodosLoaded(todos));
    } catch (e) {
      emit(TodosError('Erro ao carregar tarefas'));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      try {
        await _todoRepository.insertTodo(event.todo);
        final todos = await _todoRepository.getTodos();
        emit(TodosLoaded(todos));
      } catch (e) {
        emit(TodosError('Erro ao adicionar tarefa'));
      }
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      try {
        await _todoRepository.updateTodo(event.todo);
        final todos = await _todoRepository.getTodos();
        emit(TodosLoaded(todos));
      } catch (e) {
        emit(TodosError('Erro ao atualizar tarefa'));
      }
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodosLoaded) {
      try {
        await _todoRepository.deleteTodo(event.id);
        final todos = await _todoRepository.getTodos();
        emit(TodosLoaded(todos));
      } catch (e) {
        emit(TodosError('Erro ao deletar tarefa'));
      }
    }
  }
}
