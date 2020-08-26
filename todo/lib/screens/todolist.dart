import 'package:flutter/material.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/util/dbhelper.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add new Todo',
        child: new Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: getColor(this.todos[position].priority),
                  child: Text(this.todos[position].priority.toString()),
                ),
                title: Text(this.todos[position].title),
                subtitle: Text(this.todos[position].date),
                onTap: () {
                  debugPrint('Tapped on ' + this.todos[position].id.toString());
                }),
          );
        });
  }

  void getData() {
    // initialize() method creates the database
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodo();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint('Items' + count.toString());
      });
    });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
        break;

      default:
        return Colors.green;
    }
  }
}