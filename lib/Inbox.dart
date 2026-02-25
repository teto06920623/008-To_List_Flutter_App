
// ignore: file_names
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

      body: inboxTasks.isEmpty
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
