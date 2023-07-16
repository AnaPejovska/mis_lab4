import 'package:flutter/material.dart';
import '../model/list_item.dart';
import '../widgets/nov_element.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authentication/authentication.dart';
import '../screens/calendar-screen.dart';
import '../screens/calendar-utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<ListItem> _userItems = [
    ListItem(id: "Course1", course: "Mobile Information System", date: DateTime(2023, 06, 20, 09, 30)),
    ListItem(id: "Course2", course: "Management Information System", date: DateTime(2023, 06, 21, 12, 00))
  ];

  final AuthService _authService = AuthService();
  User? _user;

  void _checkUserLoggedIn() async {
    final User? user = await _authService.currentUser;
    if (user != null) {
      setState(() {
        _user = user; //vo promenlivata gore go stavame najaveniot user
      });
    }
  }

  @override
  void initState() { //odma vo init metod da se povika proverka koj user e najaven i da se smesti vo taa promenliva
    super.initState();
    _checkUserLoggedIn();
  }

  void _addItemFunction(BuildContext ct){
    showModalBottomSheet(context:ct, builder: (BuildContext context) {
      return GestureDetector(
          onTap: () {},
          child: NovElement(_addNewItemToList),
          behavior: HitTestBehavior.opaque
      );
    });
  }

  void _addNewItemToList(ListItem item){
    setState(() {_userItems.add(item);
    });
  }

  void _deleteItem(String id){
    setState(() {
      _userItems.removeWhere((e) => e.id == id);
    });
  }

  void _showLoginForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _emailController = TextEditingController();
        final TextEditingController _passwordController = TextEditingController();

        return AlertDialog(
          title: Text('Log in'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: (){
                final String email = _emailController.text.trim();
                final String password = _passwordController.text;
                _signInWithEmailAndPassword(email, password);
              },
              child: Text('Log in'),
            ),
          ],
        );
      },
    );
  }

  void _signInWithEmailAndPassword(String email, String password) async {
    try {
      final User? user =
      await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        setState(() {
          _user = user;
        });
        Navigator.of(context).pop();
      }
    } catch (error) {
      setState(() {
        // Handle the error
      });
    }
  }

  void _signOut() async {
    await _authService.signOut();
    setState(() {
      _user = null;
    });
  }

  void _showCalendarScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CalendarScreen(exams: _userItems))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Exams"),
            actions: [
              ElevatedButton(
                  onPressed: () => _addItemFunction(context),
                  child: Row(
                    children: [
                    Icon(Icons.add), // Icon widget
                    SizedBox(width: 8), // Optional spacing between the icon and label
                    Text('Add exam'), // Text label for the button
                  ],
        ),),
              ElevatedButton(
                onPressed: _showCalendarScreen,
                child: Icon(Icons.calendar_today),
              ),
              if(_user == null)
                ElevatedButton(
                  onPressed: _showLoginForm,
                  child: Row(
                    children: [
                      Icon(Icons.login_sharp), // Icon widget
                      SizedBox(width: 8), // Optional spacing between the icon and label
                      Text('Log in'), // Text label for the button
                    ],
                  ),
                ),
              if(_user != null)
                ElevatedButton(
                  onPressed: _signOut,
                  child: Row(
                    children: [
                      Icon(Icons.logout_sharp), // Icon widget
                      SizedBox(width: 8), // Optional spacing between the icon and label
                      Text('Log out'), // Text label for the button
                    ],
                  ),
                ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () => {},
              ),
            ],
        ),
        body: Center(
            child: _userItems.isEmpty
              ? Text("No exams")
              : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ListTile(
                  title: Text(
                    _userItems[index].course,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  subtitle: Text(
                    "Date: " + _userItems[index].date.day.toString()
                        + "." + _userItems[index].date.month.toString()
                        + "." + _userItems[index].date.year.toString()
                        + "   Time: " + _userItems[index].date.hour.toString()
                        + ":" + _userItems[index].date.minute.toString(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteItem(_userItems[index].id),
                  ),
                ),
              );
            },
            itemCount: _userItems.length,
          ),
        )
    );
  }
}