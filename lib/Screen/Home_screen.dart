import 'package:flutter/material.dart';
import 'package:offlinedatabase/Services/Database_service.dart';
import 'package:offlinedatabase/utility/Contact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  final _formkey = GlobalKey<FormState>();
  String _name = '';
  String _phobe = '';

  Contact? _deletedContact; // To store the deleted contact temporarily
  int? _deletedContactIndex; // To store the index of the deleted contact

  void _onsaved() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      _databaseService.AddContact(_name, _phobe);
      Navigator.pop(context);
    }
  }

  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _adtaskbutton(context),
      body: _bodycontent(),
    );
  }

  Widget _adtaskbutton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (cntx) => AlertDialog(
                  title: const Text("Add Contact"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _name = value as String;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Phone Number';
                                  } 
                                   else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _phobe = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Phone",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  TextButton(
                                      onPressed: () {
                                        _formkey.currentState!.reset();
                                        setState(() {
                                          _name = '';
                                          _phobe = '';
                                        });
                                      },
                                      child: const Text(
                                        "reset",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 107, 129, 136)),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  OutlinedButton(
                                      onPressed: _onsaved,
                                      child: const Text("save")),
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                ));
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _bodycontent() {
    return FutureBuilder(
      future: _databaseService.getContact(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data'));
        }
        return Padding(
          padding: EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Contact contact = snapshot.data![index];
                return Dismissible(
                  background: const DecoratedBox(
                      decoration: BoxDecoration(
                    color: Color.fromARGB(29, 244, 67, 54),
                  )),
                  key: Key(contact.id.toString()),
                  onDismissed: (direction) =>
                      _deleteContact(contact, index), // Delete contact
          
                  child: Card(
                    shadowColor:Colors.white24,
                    color: Theme.of(context).colorScheme.background,
                    child: ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),
                      leading: Text(contact.id.toString()),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  // Function to handle contact deletion
  void _deleteContact(Contact contact, int index) {
    setState(() {
      _databaseService.getremove(contact.id); // Remove from the database
      _deletedContact = contact; // Temporarily save deleted contact
      _deletedContactIndex = index; // Save index for restoring later
    });

    // Show SnackBar with Undo action
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${contact.name} deleted'),
        action: SnackBarAction(
          label: "Undo", textColor: Color.fromARGB(200, 44, 51, 53),
          onPressed: () {
            // Restore the contact if Undo is clicked
            _restoreContact();
          },
        ),
      ),
    );
  }

  // Function to restore a contact to its previous index and id
  void _restoreContact() {
    if (_deletedContact != null && _deletedContactIndex != null) {
      setState(() {
        _databaseService.addContactWithID(_deletedContact!); // Restore contact with the same ID
        _deletedContact = null; // Clear temporary data
        _deletedContactIndex = null; // Clear temporary index
      });
    }
  }
}
