import 'package:hive_flutter/hive_flutter.dart';

class TodoDataBase{

  List ToDoList=[];

  //reference the box
  final _mybox = Hive.box('mybox');

  //run this method if this is the 1st time ever opening this app

  void createInitialData(){
    ToDoList=[
      // ["Make Tutorial",false],
      ["Do Workout",false],
    ];
  }

  //load the data from database

  void loadData(){
    ToDoList=_mybox.get("TODOLIST");

  }

  //update the database
  void updateDataBase(){
    _mybox.put("TODOLIST", ToDoList);

  }
}