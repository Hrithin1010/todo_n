import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_n/db/database.dart';
import 'package:todo_n/utils/dialog_box.dart';
import 'package:todo_n/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference the hive box
  final _mybox = Hive.box('mybox');

  TodoDataBase db = TodoDataBase();

  @override
  void initState() {
    //if this is the 1st time ever opening the app,then create default data
    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      //there already exists data
      db.loadData();
    }
    super.initState();
  }

  final _controller = TextEditingController();

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.ToDoList[index][1] = !db.ToDoList[index][1];
    });
    db.updateDataBase();
  }

//save new task
  void saveNewTask() {
    setState(() {
      db.ToDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

//create new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      db.ToDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromARGB(255, 172, 232, 174),
      // Colors.green[200],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 56, 138, 59),
        title: Text('TO DO',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 56, 138, 59),
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: db.ToDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.ToDoList[index][0],
              taskCompleted: db.ToDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ),
      ),
    );
  }
}
