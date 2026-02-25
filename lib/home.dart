import 'package:flutter/material.dart';
import 'package:to_do_list/Inbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> myNotes = [];
  List<Map<String, dynamic>> myProjects = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? notesString = prefs.getString('saved_notes');
      if (notesString != null) {
        myNotes = List<Map<String, dynamic>>.from(jsonDecode(notesString));
      }

      String? projectsString = prefs.getString('saved_projects');
      if (projectsString != null) {
        myProjects = List<Map<String, dynamic>>.from(
          jsonDecode(projectsString),
        );
      } else {
        myProjects = [
          {'name': 'Personal', 'color': Colors.red},
          {'name': 'Errands', 'color': Colors.deepOrange},
          {'name': 'Fitnesss', 'color': Colors.orange},
        ];
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_notes', jsonEncode(myNotes));
    await prefs.setString('saved_projects', jsonEncode(myProjects));
  }

  void _showAddProjectDialog() {
    TextEditingController _projController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Project"),
        content: TextField(
          controller: _projController,
          decoration: const InputDecoration(hintText: "Project Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_projController.text.isNotEmpty) {
                setState(() {
                  myProjects.add({
                    'name': _projController.text,
                    'color': Colors.blueGrey.value,
                  });
                });
                _saveData();
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add note"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: "Title"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_titleController.text.isNotEmpty ||
                          _descriptionController.text.isNotEmpty) {
                        myNotes.add({
                          "title": _titleController.text.isEmpty
                              ? "No Title"
                              : _titleController.text,
                          "description": _descriptionController.text.isEmpty
                              ? "No Description"
                              : _descriptionController.text,
                        });
                        _saveData();
                      }
                    });
                    _titleController.clear();
                    _descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Note book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              color: Colors.teal,
              child: const Row(
                children: [
                  Icon(Icons.pie_chart_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "3/5",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 16),
                  Icon(Icons.notifications_none, color: Colors.white),
                  SizedBox(width: 16),
                  Icon(Icons.settings, color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView(
                header: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Inbox(),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.inbox, color: Colors.blue),
                        title: Text("Inbox"),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.green),
                      title: Text("Today"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.calendar_month, color: Colors.purple),
                      title: Text("Upcoming"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Projects",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: _showAddProjectDialog,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = myProjects.removeAt(oldIndex);
                    myProjects.insert(newIndex, item);
                  });
                  _saveData();
                },
                children: [
                  for (int i = 0; i < myProjects.length; i++)
                    ListTile(
                      key: ValueKey(myProjects[i]['name'] + i.toString()),
                      leading: Icon(
                        Icons.circle,
                        size: 12,
                        color: Color(myProjects[i]['color']),
                      ),
                      title: Text(myProjects[i]['name']),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            myProjects.removeAt(i);
                          });
                          _saveData();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: myNotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done_all, size: 120, color: Colors.grey[300]),
                  const SizedBox(height: 24),
                  const Text(
                    "All clear",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Looks like everything's organized in the right place. Tap + to add a task.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: myNotes.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            myNotes[index]['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                myNotes.removeAt(index);
                              });
                              _saveData();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        myNotes[index]['description']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
