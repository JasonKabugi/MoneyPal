import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

TextEditingController usernameController =
    TextEditingController(); //to access what is inside the textfield
TextEditingController passwordController = TextEditingController();
var store = GetStorage();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    usernameController.text = store.read("username") ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("MoneyPal"),
        backgroundColor: tertiaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          Icon(Icons.search),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("t1.png", height: 300, width: 600)],
            ),

            Text(
              "Username:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: sevenColor,
              ),
            ),
            TextField(
              controller:
                  usernameController, //to asociate with the textfield controller
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            Text(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: sevenColor,
              ),
              "Password:",
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () async {
                    var response = await http.get(
                      Uri.parse(
                        "http://localhost/expenses/login.php?phone=${usernameController.text}&password=${passwordController.text}",
                      ),
                    );
                    var responseBody = jsonDecode(response.body);
                    int loggedIn = responseBody['success'];
                    if (loggedIn == 1) {
                      store.write('username', usernameController.text);
                      Get.toNamed("/home");
                    } else {
                      Get.snackbar("Error", "Invalid Username or Password");
                    }
                  },
                  color: fiveColor,
                  height: 45,
                  minWidth: 200,
                  child: Text("Login"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text(
                    "Not registered? SignUp",
                    style: TextStyle(color: fourColor),
                  ),
                  onTap: () {
                    //code to navigate
                    Get.toNamed("/register");
                  },
                ),

                Spacer(),

                Text(
                  "Forgot Password? Reset",
                  style: TextStyle(color: fourColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
