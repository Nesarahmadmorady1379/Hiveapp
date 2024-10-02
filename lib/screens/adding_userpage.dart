import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hiveapp/moodle/modle.dart';
import 'package:hiveapp/screens/saveddata.dart';

class AddingUserPage extends StatefulWidget {
  final nots?
      noteData; // User data passed for editing (can be null if adding a new user)

  const AddingUserPage({Key? key, this.noteData}) : super(key: key);

  @override
  _AddingUserPageState createState() => _AddingUserPageState();
}

class _AddingUserPageState extends State<AddingUserPage> {
  final _titleController = TextEditingController();
  final _discriptionController = TextEditingController();
  final String boxname = 'notesbox';
  late Box<nots> notsBox;
  @override
  void initState() {
    super.initState();
    _openbox();
    if (widget.noteData != null) {
      _titleController.text = widget.noteData!.title;
      _discriptionController.text = widget.noteData!.discription;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.noteData != null ? 'Edit User' : 'Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Enter Title',
                  labelStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            TextField(
              maxLines: 5,
              controller: _discriptionController,
              decoration: InputDecoration(
                label: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Description',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text(widget.noteData != null ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitData() async {
    final tile = _titleController.text;
    final discription = _discriptionController.text;
    if (tile.isEmpty || discription.isEmpty) {
      _showErrorDialog('All fields are required!');
      return;
    }
    if (widget.noteData != null) {
      widget.noteData!.title = tile;
      widget.noteData!.discription = discription;
      widget.noteData!.save();
    } else {
      final newnote = nots(title: tile, discription: discription);
      await notsBox.add(newnote);
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SavedDataPage()));
    _titleController.clear();
    _discriptionController.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SavedDataPage()));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openbox() async {
    notsBox = await Hive.openBox(boxname);
  }
}
