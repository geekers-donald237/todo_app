import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/services/todo_services.dart';

final serviceProvider = StateProvider<TodoService>((ref) {
  return TodoService();
})