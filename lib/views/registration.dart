import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';

TextEditingController usernameController =
    TextEditingController(); //to access what is inside the textfield
TextEditingController passwordController = TextEditingController();
TextEditingController phoneController = TextEditingController();
var store = GetStorage();

class Registrationscreen extends StatelessWidget {
  const Registrationscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MoneyPal"),
        backgroundColor: tertiaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("t1.png", height: 100, width: 200)],
            ),

            Text(
              "Registration",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: sevenColor,
              ),
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
              "Email:",
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
              "Phone:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: sevenColor,
              ),
            ),
            TextField(
              controller:
                  phoneController, //to asociate with the textfield controller
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

            Text(
              "Confirm Password:",
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

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    store.write('username', usernameController.text);
                    Get.toNamed("/home");
                  },
                  color: fiveColor,
                  height: 45,
                  minWidth: 200,
                  child: Text("Register"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text(
                    "Already Have an Account? SignIn",
                    style: TextStyle(color: fourColor),
                  ),
                  onTap: () {
                    //code to navigate
                    Get.toNamed("/login");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
