import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveapp/moodle/modle.dart';
import 'package:hiveapp/screens/adding_userpage.dart';
import 'package:hiveapp/screens/login.dart';
import 'package:hiveapp/screens/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedDataPage extends StatefulWidget {
  @override
  _SavedDataPageState createState() => _SavedDataPageState();
}

class _SavedDataPageState extends State<SavedDataPage> {
  late Box<nots> notsBox;
  final String boxname = 'notesbox';
  late SharedPreferences logindata;
  bool _isBoxOpen = false; // To track if the Hive box is open
  bool _isSearching = false; // To track the search state
  List<nots> _filteredNotes = []; // To store filtered notes
  TextEditingController _searchController =
      TextEditingController(); // Controller for the search field

  @override
  void initState() {
    super.initState();
    _openbox();
    _searchController
        .addListener(_filterNotes); // Add listener to the search field
  }

  Future<void> _openbox() async {
    notsBox = await Hive.openBox<nots>(boxname);
    setState(() {
      _isBoxOpen = true;
      _filteredNotes = notsBox.values.toList(); // Initialize with all notes
    });
  }

  // Filter notes based on search query
  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        _filteredNotes = notsBox.values
            .where((note) => note.title.toLowerCase().contains(query))
            .toList();
      });
    } else {
      setState(() {
        _filteredNotes = notsBox.values.toList(); // Reset if no query
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 100,
        child: ListView(
          children: [
            DrawerHeader(
                child: CircleAvatar(
              child: Text(
                'N',
                style: TextStyle(fontSize: 28),
              ),
            )),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                icon: Icon(
                  Icons.settings,
                  size: 50,
                )),
            IconButton(
                onPressed: () async {
                  logindata = await SharedPreferences.getInstance();
                  logindata.setBool('login', true);
                  Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (context) => login()));
                },
                icon: Icon(
                  Icons.logout,
                  size: 50,
                )),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              )
            : Text('Saved Data'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching; // Toggle search mode
                if (!_isSearching) {
                  _searchController.clear(); // Clear search field when closed
                }
              });
            },
          ),
        ],
      ),
      body: _isBoxOpen // Ensure the box is opened
          ? ValueListenableBuilder(
              valueListenable: Hive.box<nots>(boxname).listenable(),
              builder: (context, Box<nots> box, _) {
                if (_filteredNotes.isEmpty) {
                  return Center(
                    child: Text('No notes available.'),
                  );
                } else {
                  return ListView.builder(
                      itemCount: _filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = _filteredNotes[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              note.title,
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              note.discription,
                              style: TextStyle(fontSize: 14),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddingUserPage(
                                            noteData: note,
                                          )));
                            },
                            trailing: IconButton(
                                onPressed: () {
                                  note.delete();
                                  _filterNotes(); // Refilter after deletion
                                },
                                icon: Icon(Icons.delete)),
                          ),
                        );
                      });
                }
              },
            )
          : Center(
              child:
                  CircularProgressIndicator(), // Show loading while box opens
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddingUserPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
