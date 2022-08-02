class GenreModel{

  int id;
  String name;

  GenreModel(this.id, this.name,);

  GenreModel.fromJson(json){

    id = json['id'];
    name = json['name'];
    
  }


}