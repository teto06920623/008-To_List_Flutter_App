// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:to_do_list/Inbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:to_do_list/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isDarkMode = false;

  List<Map<String, dynamic>> myNotes = [];
  List<Map<String, dynamic>> myProjects = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? notesString = prefs.getString('saved_notes');
    String? projectsString = prefs.getString('saved_projects');
    bool? savedDarkMode = prefs.getBool('is_dark_mode');

    setState(() {
      if (notesString != null) {
        myNotes = List<Map<String, dynamic>>.from(jsonDecode(notesString));
      }
      if (savedDarkMode != null) {
        _isDarkMode = savedDarkMode;
      }

      if (projectsString != null) {
        myProjects = List<Map<String, dynamic>>.from(
          jsonDecode(projectsString),
        );
      } else {
        myProjects = [
          {'name': 'Personal', 'color': Colors.red.value},
          {'name': 'Errands', 'color': Colors.deepOrange.value},
          {'name': 'Fitnesss', 'color': Colors.orange.value},
        ];
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_notes', jsonEncode(myNotes));
    await prefs.setString('saved_projects', jsonEncode(myProjects));
    await prefs.setBool('is_dark_mode', _isDarkMode);
  }

  void _showAddProjectDialog() {
    TextEditingController _ProjController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Project"),
        content: TextField(
          controller: _ProjController,
          decoration: const InputDecoration(hintText: "Project Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_ProjController.text.isNotEmpty) {
                setState(() {
                  myProjects.add({
                    'name': _ProjController.text,
                    'color': Colors.teal.value,
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
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
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
        backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
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
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Settings()),
                      );
                    },
                    child: const Icon(Icons.settings, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isDarkMode = !_isDarkMode;
                      });
                      _saveData();
                    },
                    child: Icon(
                      _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                      color: Colors.white,
                    ),
                  ),
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
                      child: ListTile(
                        leading: const Icon(Icons.inbox, color: Colors.blue),
                        title: Text(
                          "Inbox",
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.calendar_today,
                        color: Colors.green,
                      ),
                      title: Text(
                        "Today",
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.calendar_month,
                        color: Colors.purple,
                      ),
                      title: Text(
                        "Upcoming",
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Projects",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[800],
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
                    if (oldIndex < newIndex) newIndex -= 1;
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
                        color: Color(myProjects[i]['color'] as int),
                      ),
                      title: Text(
                        myProjects[i]['name'],
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
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
      body: myNotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done_all, size: 120, color: Colors.grey[300]),
                  const SizedBox(height: 24),
                  Text(
                    "All clear",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white70 : Colors.black87,
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
                        color: _isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[600],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
