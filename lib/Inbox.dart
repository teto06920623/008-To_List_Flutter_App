// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  // قائمة مهام خاصة بصندوق الوارد (فاضية حالياً عشان نظهر الـ Empty State)
  List<Map<String, String>> inboxTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Inbox",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        // iconTheme دي عشان تخلي سهم الرجوع لونه أبيض بدل الأسود الافتراضي
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
      
      body:
        inboxTasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 120,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Your inbox is empty",
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
                      "Tasks added here will stay until you organize them into projects.",
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
              itemCount: inboxTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(inboxTasks[index]['title']!),
                  subtitle: Text(inboxTasks[index]['description']!),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Ready to add inbox tasks!"),
              backgroundColor: Colors.teal,
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
