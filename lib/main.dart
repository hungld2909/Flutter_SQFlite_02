import 'package:flutter/material.dart';
import 'package:sqflite_database/TaskModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();

  List<TaskModel> tasks = [];

  TaskModel currentTask;

  @override
  Widget build(BuildContext context) {
    final TodoHelper _todoHelper = TodoHelper();
    return Scaffold(
      appBar: AppBar(
        title: Text("SQflite Demo"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: textController,
              ),
              FlatButton(
                onPressed: () {
                  currentTask = TaskModel(name: textController.text);
                  _todoHelper.insertTask(currentTask);
                },
                child: Text("Insert"),
                color: Colors.blue,
                textColor: Colors.white,
              ),
              FlatButton(
                onPressed: () async {
                  List<TaskModel> list = await _todoHelper.getAllTask();
                  setState(() {
                    tasks = list;
                  });
                },
                child: Text("Show All Task"),
                color: Colors.red,
                textColor: Colors.white,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("${tasks[index].id}"),
                      title: Text("${tasks[index].name}"),
                      trailing: InkWell(
                          onTap: () {
                            print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA${tasks[index].id}");

                            _todoHelper.deleteTask(tasks[index].id);
                          },
                          child: Icon(Icons.delete)),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: tasks.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
