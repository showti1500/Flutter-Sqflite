import 'dart:convert';

class Profile{
  int id;
  String name;
  String email;
  int age;

  Profile({
    this.id=0,
    this.name,
    this.email,
    this.age
  });

  factory Profile.fromJson(Map<String,dynamic> map){
    return Profile(
      id:map["id"],
      name:map["name"],
      email:map["email"],
      age:map["age"]
    );
  }
  Map<String,dynamic> toJson(){
    return {"name":name, "email":email,"age":age};
  }

   Map<String,dynamic> toIdJson(){
    return {"id":id,"name":name, "email":email,"age":age};
  }

  @override
  String toString(){
    return 'Profile{id:$id,name:$name,email:$email,age:$age}';
  }
  
  List<Profile> profileFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<Profile>.from(data.map((item)=>Profile.fromJson((item))));
  }

  void profileGGEE(){
    print('gg');
  }

  String profileToJson(Profile data){
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }

  String profileToIdJson(Profile data){
    final jsonData = data.toIdJson();
    return json.encode(jsonData);
  }

}