class MovieModel{

  int idFavo;
  int idMovie;
  String image;
  String backdrop;
  String title;
  List genre;
  dynamic rate;
  dynamic voteCount;
  dynamic popularity;
  String overview;
  bool adult;
  bool favorite;

  MovieModel(this.idFavo, this.idMovie, this.image, this.backdrop, this.title, this.genre, this.rate, this.voteCount, this.popularity, this.overview, this.adult, this.favorite,);

  MovieModel.fromJson(json, action){

    idFavo = action == 20 ? json['id'] : 1;
    idMovie = action == 20 ? json['idmovie'] : json['id'];
    image = json['poster_path'];
    backdrop = json['backdrop_path'];
    title = json['title'];
    genre = action == 20 ? json['genre_ids'].toString().split(', ') : json['genre_ids'];
    rate = json['vote_average'];
    voteCount = json['vote_count'];
    popularity = json['popularity'];
    overview = json['overview'];
    adult = action == 20 ? json['adult'] == 1 ? true : false : json['adult'];
    favorite = action == 20 ? true : false;
    
  }


}