import 'package:flutter_login/database/database_provider.dart';
import 'package:flutter_login/models/todo.dart';
import 'package:sqflite/sqflite.dart';

class TodoRepository {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  Future<Database> get _db async => await _databaseProvider.database;

  Future<List<Todo>> getTodos() async {
    final db = await _db;
    final result = await db.query('todos');
    return result.map((json) => Todo.fromMap(json)).toList();
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await _db;
    await db.insert('todos', todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await _db;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await _db;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
