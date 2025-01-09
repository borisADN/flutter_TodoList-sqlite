import 'package:flutter/material.dart';
import 'package:todo_list_sql/data/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove this line for production
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _todos = [];
  final _controller = TextEditingController();

  void addTask() async {
    if (_controller.text.trim().isEmpty) return; // Check if the text is empty
    await DbHelper.addTask(_controller.text);
    _controller.clear();
    fetchTasks(); // Fetch updated tasks
  }

  void fetchTasks() async {
    final todos = await DbHelper.getAllTasks();
    setState(() {
      _todos = todos;
    });
  }

  void deleteTask(int id) async {
    await DbHelper.deleteTask(id);
    fetchTasks(); // Fetch updated tasks
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("TODOLIST SQLite"),
      ),
      body: SafeArea(
          child: Column(children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a task',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      addTask();
                    },
                  ))),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  onLongPress: () {
                    deleteTask(todo['id']);
                  },
                  title: Text(
                    todo['task'],
                    style: TextStyle(
                        decoration: todo['done'] == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  trailing: Checkbox(
                      value: todo['done'] == 1,
                      onChanged: (value) async {
                        await DbHelper.updateTask(todo['id'], value! ? 1 : 0);
                        fetchTasks();
                      }),
                );
              }),
        )
      ])),
    );
  }
}
