import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memovie/db/dbhelper.dart';
import 'package:memovie/model/mgenre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memovie/model/mmovie.dart';
import 'package:memovie/model/muser.dart';
import 'package:http/http.dart' as api;

class MainProvider extends ChangeNotifier {

  static final String token = 'b3d1849325319b63e66eed43334fe3b6';
  static final String baseURL = 'api.themoviedb.org';
  static final String nowplaying = '/3/movie/now_playing';
  static final String upcoming = '/3/movie/upcoming';
  String name; 
  String email; 
  String password; 
  String repass;
  String releaseDate;
  String genreMovie;
  String newName;

  int idUser;
  int durationMovie;

  bool buttonActiveLoginn = false;
  bool loadingLogin = false;
  bool readOnlyLogin = false;
  bool obscureTextLogin = true;
  bool buttonActiveRegister = false;
  bool loadingRegister = false;
  bool readOnlyRegister = false;
  bool obscureTextRegis = true;
  bool obscureTextConfirmRegis = true;
  bool readOnlyEdit = false;
  bool buttonActiveEdit = false;
  
  List<UserModel> listUsers = new List<UserModel>();
  List<MovieModel> listNowplayingMovies = new List<MovieModel>();
  List<MovieModel> listUpcomingMovies = new List<MovieModel>();
  List<MovieModel> listRecomenMovies = new List<MovieModel>();
  List<MovieModel> listFavoriteMovies = new List<MovieModel>();
  List<GenreModel> listGenre = new List<GenreModel>();

  final sqflite = DBHelper();

  //! ALL METHOD & FUNCTION ====================================================

  Future<bool> getCurrentUser() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool auth = preferences.getBool('auth') ?? false;
    idUser = preferences.getInt('idUser');
    name = preferences.getString('nameUser');
    email = preferences.getString('emailUser');

    if(auth){
      final getFavoriteMovie = await sqflite.getAllFavoriteMovie(idUser: idUser);
      List listFavorite = jsonDecode(getFavoriteMovie);
      listFavoriteMovies = listFavorite.map((e) => MovieModel.fromJson(e, 20)).toList();
    }
    
    notifyListeners();

    return auth ?? false;

  }

  setInputValueLogin({int type, dynamic value}){
    if(type == 10){
      email = value;
    } else {
      password = value;
    }
    buttonActiveLogin();
  }

  buttonActiveLogin(){
    if(EmailValidator.validate(email) && password.length > 5){
      buttonActiveLoginn = true;
    } else{
      buttonActiveLoginn = false;
    }
    notifyListeners();
  }

  changeObscureTextLogin(){
    obscureTextLogin = !obscureTextLogin;
    notifyListeners();
  }

  setInputValueRegister({int type, dynamic value}){
    if(type == 10){
      name = value;
    } else if(type == 20){
      email = value;
    } else if(type == 30){
      password = value;
    } else {
      repass = value;
    }
    buttonActiveRegis();
  }

  buttonActiveRegis(){
    if(name.length > 2 && EmailValidator.validate(email) && password.length > 5 && repass.length > 5 && repass == password){
      buttonActiveRegister = true;
    } else{
      buttonActiveRegister = false;
    }
    notifyListeners();
  }

  changeObscureTextRegister({int type}){
    if(type == 10){
      obscureTextRegis = !obscureTextRegis;
    } else {
      obscureTextConfirmRegis = !obscureTextConfirmRegis;
    }
    notifyListeners();
  }

  setInputValueEdit({dynamic value}){
    newName = value;
    buttonActiveEditt();
  }

  buttonActiveEditt(){
    if(newName.length > 2 && newName != name){
      buttonActiveEdit = true;
    } else{
      buttonActiveEdit = false;
    }
    notifyListeners();
  }

  Future<int> loginUser({@required BuildContext context,}) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int result = 1;

    loadingLogin = true;
    readOnlyLogin = true;
    notifyListeners();

    final getUser = await sqflite.getUserWhereEmail(email: email);
    List listUser = jsonDecode(getUser);
    listUsers = listUser.map((e) => UserModel.fromJson(e)).toList();

    if(listUsers.isNotEmpty){

      if(listUsers.first.password == password){

        preferences.setBool('auth', true);
        preferences.setInt('idUser', listUsers.first.id);
        preferences.setString('nameUser', listUsers.first.name);
        preferences.setString('emailUser', listUsers.first.email);
        email = null;
        password = null;
        loadingLogin = false;
        readOnlyLogin = false;
        buttonActiveLoginn = false;
        idUser = listUsers.first.id;
        name = listUsers.first.name;
        email = listUsers.first.email;
        notifyListeners();

        final getFavoriteMovie = await sqflite.getAllFavoriteMovie(idUser: idUser);
        List listFavorite = jsonDecode(getFavoriteMovie);
        listFavoriteMovies = listFavorite.map((e) => MovieModel.fromJson(e, 20)).toList();

      } else {

        result = 2;
        password = null;
        loadingLogin = false;
        readOnlyLogin = false;
        buttonActiveLoginn = false;
        notifyListeners();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Your password don't match!",
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    height: 1.4,
                  ),
                )
              ],
            ),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                ),
              )
            ],
          )
        );

      }

    } else {

      result = 0;
      email = null;
      password = null;
      loadingLogin = false;
      readOnlyLogin = false;
      buttonActiveLoginn = false;
      notifyListeners();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Your email is not registered. Create your new account to start using MeMovie.',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  height: 1.4,
                ),
              )
            ],
          ),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                'OK',
              ),
            )
          ],
        )
      );

    }

    return result;

  }

  Future<bool> registerUser({@required BuildContext context}) async {

    bool result = true;

    loadingRegister = true;
    readOnlyRegister = true;
    notifyListeners();

    final getUser = await sqflite.getUserWhereEmail(email: email);
    List listUser = jsonDecode(getUser);
    listUsers = listUser.map((e) => UserModel.fromJson(e)).toList();

    if(listUsers.isNotEmpty){

      result = false;
      loadingRegister = false;
      readOnlyRegister = false;
      notifyListeners();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Your email has been registered before. Use a different email to create a new account.',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  height: 1.4,
                ),
              )
            ],
          ),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                'OK',
              ),
            )
          ],
        )
      );

    } else {

      dynamic newUser = {
        'name': name,
        'email': email,
        'pass': password,
      };

      int saveUser = await sqflite.saveUser(user: newUser);

      if(saveUser != null){

        name = null;
        email = null;
        password = null;
        repass = null;
        loadingRegister = false;
        readOnlyRegister = false;
        buttonActiveRegister = false;
        notifyListeners();

      } else {

        result = false;
        loadingRegister = false;
        readOnlyRegister = false;
        notifyListeners();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Unable to register a new account at this time, please try again in a few moments.',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    height: 1.4,
                  ),
                )
              ],
            ),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                ),
              )
            ],
          )
        );

      }

    }

    return result;

  }

  Future<void> onRefresh({@required BuildContext context}) async {

    await getNowPlayMovie();
    await getUpcomingMovie();

  }

  Future<dynamic> getNowPlayMovie() async {

    var queryParams = {
      'api_key' : token,
      'language' : 'en-US'
    };

    var urltarget = Uri.https(baseURL, nowplaying, queryParams);
    api.Response result = await api.get(urltarget);

    if (result != null){

      var resultMovie = jsonDecode(result.body);
      List nowplay = resultMovie['results'];
      listNowplayingMovies = nowplay.map((e) => MovieModel.fromJson(e, 10)).toList();

      listNowplayingMovies.forEach((movie) async {

        var checkValue = listFavoriteMovies.where((favorite) => movie.idMovie == favorite.idMovie).isNotEmpty;
        if(checkValue){
          movie.favorite = true;
        }

      });

      notifyListeners();

    }

  }

  Future<dynamic> getUpcomingMovie() async {

    var queryParams = {
      'api_key' : token,
      'language' : 'en-US'
    };

    var urltarget = Uri.https(baseURL, upcoming, queryParams);
    api.Response result = await api.get(urltarget);

    if (result != null){

      var resultMovie = jsonDecode(result.body);
      List upcoming = resultMovie['results'];
      listUpcomingMovies = upcoming.map((e) => MovieModel.fromJson(e, 10)).toList();

      listUpcomingMovies.forEach((movie) async {

        var checkValue = listFavoriteMovies.where((favorite) => movie.idMovie == favorite.idMovie).isNotEmpty;
        if(checkValue){
          movie.favorite = true;
        }

      });

      notifyListeners();

    }

  }

  Future<dynamic> getDetailsMovie({@required int idMovie}) async {

    String details = '/3/movie/$idMovie';

    var queryParams = {
      'api_key' : token,
      'language' : 'en-US'
    };

    var urltarget = Uri.https(baseURL, details, queryParams);
    api.Response result = await api.get(urltarget);

    if (result != null){

      var resultDetail = jsonDecode(result.body);
      List genre = resultDetail['genres'];
      listGenre = genre.map((e) => GenreModel.fromJson(e)).toList();

      releaseDate = resultDetail['release_date'];
      durationMovie = resultDetail['runtime'];

      int i = -1;
      listGenre.forEach((genre) {
        i++;
        if(i == 0){
          genreMovie = genre.name;
        } else {
          genreMovie = '$genreMovie, ${genre.name}';
        }
      });

      notifyListeners();

    }

  }

  Future<dynamic> getRecomendation({@required int idMovie}) async {

    String recomendation = '/3/movie/$idMovie/recommendations';

    var queryParams = {
      'api_key' : token,
      'language' : 'en-US'
    };

    var urltarget = Uri.https(baseURL, recomendation, queryParams);
    api.Response result = await api.get(urltarget);

    if (result != null){

      var resultRecomendation = jsonDecode(result.body);
      List recomendation = resultRecomendation['results'];
      listRecomenMovies = recomendation.map((e) => MovieModel.fromJson(e, 10)).toList();

      listRecomenMovies.forEach((movie) async {

        var checkValue = listFavoriteMovies.where((favorite) => movie.idMovie == favorite.idMovie).isNotEmpty;
        if(checkValue){
          movie.favorite = true;
        }

      });

      notifyListeners();

    }

  }

  Future<bool> saveFavorite({@required MovieModel movie}) async {

    bool result = false;

    dynamic dataMovie = {
      'idmovie': movie.idMovie,
      'iduser': idUser,
      'poster_path': movie.image,
      'backdrop_path': movie.backdrop,
      'title': movie.title,
      'genre_ids': genreMovie,
      'vote_average': movie.rate,
      'vote_count': movie.voteCount,
      'popularity': movie.popularity,
      'overview': movie.overview,
      'adult': movie.adult ? 1 : 0,
    };
    
    int saveResult = await sqflite.saveFavoriteMovie(movie: dataMovie);

    if(saveResult != null){
      result = true;
      movie.favorite = true;
      final getFavoriteMovie = await sqflite.getAllFavoriteMovie(idUser: idUser);
      List listFavorite = jsonDecode(getFavoriteMovie);
      listFavoriteMovies = listFavorite.map((e) => MovieModel.fromJson(e, 20)).toList();

      notifyListeners();
    }

    return result;

  }

  Future<bool> removeFavorite({@required MovieModel movie}) async {

    bool result = false;
    
    int deleteResult = await sqflite.deleteFavoriteMovie(id: movie.idFavo);

    if(deleteResult != null){
      result = true;
      movie.favorite = false;
      final getFavoriteMovie = await sqflite.getAllFavoriteMovie(idUser: idUser);
      List listFavorite = jsonDecode(getFavoriteMovie);
      listFavoriteMovies = listFavorite.map((e) => MovieModel.fromJson(e, 20)).toList();

      listNowplayingMovies.forEach((movie) async {

        var checkValue = listFavoriteMovies.where((favorite) => movie.idMovie == favorite.idMovie).isNotEmpty;
        if(checkValue){
          movie.favorite = true;
        } else { 
          movie.favorite = false;
        }

      });

      listUpcomingMovies.forEach((movie) async {

        var checkValue = listFavoriteMovies.where((favorite) => movie.idMovie == favorite.idMovie).isNotEmpty;
        if(checkValue){
          movie.favorite = true;
        } else { 
          movie.favorite = false;
        }

      });

      listRecomenMovies.forEach((movie) async {

        var checkValue = listFavoriteMovies.where((favorite) => movie.idMovie == favorite.idMovie).isNotEmpty;
        if(checkValue){
          movie.favorite = true;
        } else { 
          movie.favorite = false;
        }

      });
      
      notifyListeners();
    }

    return result;

  }

  Future<bool> updateProfile() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = false;
    readOnlyEdit = true;
    notifyListeners();

    dynamic dataUser = {
      'name': newName,
    };
    
    int updateResult = await sqflite.updateUser(idUser: idUser, newData: dataUser);

    if(updateResult != null){

      preferences.setString('nameUser', newName);
      result = true;
      name = newName;
      newName = null;
      readOnlyEdit = false;
      buttonActiveEdit = false;
      notifyListeners();

    } else {

      newName = null;
      readOnlyEdit = false;
      buttonActiveEdit = false;
      notifyListeners();

    }

    return result;

  }

  Future<bool> logout() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();

    return true;

  }

  setDefaultValue() {
    
    name = null; 
    email = null; 
    password = null; 
    repass = null;
    releaseDate = null;
    genreMovie = null;

    idUser = null;
    durationMovie = null;

    buttonActiveLoginn = false;
    loadingLogin = false;
    readOnlyLogin = false;
    obscureTextLogin = true;
    buttonActiveRegister = false;
    loadingRegister = false;
    readOnlyRegister = false;
    obscureTextRegis = true;
    obscureTextConfirmRegis = true;
    
    listUsers = new List<UserModel>();
    listNowplayingMovies = new List<MovieModel>();
    listUpcomingMovies = new List<MovieModel>();
    listRecomenMovies = new List<MovieModel>();
    listFavoriteMovies = new List<MovieModel>();
    listGenre = new List<GenreModel>();
    
  }

  Future<bool> onWillpopRegister() async {

    name = null; 
    email = null; 
    password = null; 
    repass = null;
    buttonActiveRegister = false;
    loadingRegister = false;
    readOnlyRegister = false;
    obscureTextRegis = true;
    obscureTextConfirmRegis = true;
    notifyListeners();

    return true;

  }

}