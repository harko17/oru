import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class ConfirmNameScreen extends StatefulWidget {
  @override
  _ConfirmNameScreenState createState() => _ConfirmNameScreenState();
}

class _ConfirmNameScreenState extends State<ConfirmNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _saveName() async {
    String countryCode = "91"; // Replace with actual value
    String csrfToken = "your_csrf_token"; // Retrieve from storage or API response

    var response = await ApiService.updateUser(countryCode, _nameController.text, csrfToken);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      print("Error: ${response.body}"); // Handle API failure
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Name")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveName, child: Text("Save Name")),
          ],
        ),
      ),
    );
  }
}
