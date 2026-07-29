import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:flutter_application_1/views/registration.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

var routes = [
  GetPage(name: "/", page: () => LoginScreen()),
  GetPage(name: "/register", page: () => Registrationscreen()),
  GetPage(name: "/home", page: () => HomeScreen()),
  GetPage(name: "/dashboard", page: () => Dashboard()),
];
