import 'package:flutter/material.dart';

class UserModel {

  int id;
  String name, email, password;

  UserModel({ @required this.id, @required this.name, @required this.email, @required  this.password});

  UserModel.fromJson(json) {

    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['pass'];

  }

}