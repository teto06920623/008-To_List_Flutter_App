import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String enteredTitle = "To do list";
  String enteredDescription = "description";
  List<Map<String, String>> myNotes = [];
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
          setState(() {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Add note"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(hintText: "Description"),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
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
                        }
                      });

                      _titleController.clear();
                      _descriptionController.clear();

                      Navigator.pop(context);
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
            );
          });
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(
          "Note book",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),

      body: myNotes.isEmpty
          ? Center(
              child: Text(
                "No Notes Available",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: myNotes.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  height: 90,
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                enteredTitle = "To do list";
                                enteredDescription = "description";
                              });
                              _titleController.clear();
                              _descriptionController.clear();
                            },
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  myNotes.removeAt(index);
                                });
                              },
                              child: Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        myNotes[index]['description']!,
                        style: TextStyle(
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
