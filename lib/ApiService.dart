
import 'package:crudtest/model/profile.dart';
import 'package:http/http.dart'show Client;

class ApiService extends Profile{
 
  

   final String baseUrl= "https://api.showti.tk/public";
  //final String baseUrl= "http://192.168.1.6:8000";
  Client client=Client();
  Future<List<Profile>> getProfiles() async {
    final response = await client.get("$baseUrl/api/profile");
    if(response.statusCode==200){
       return profileFromJson(response.body);
    }
    else{
      return null;
    }

  }

  Future<bool> createProfile(Profile data) async{
    final response = await client.post(
      "$baseUrl/api/profile/create",
      headers: {"Content-type":"application/json"},
      body: profileToJson(data),
    );
    if(response.statusCode==201){
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> updateProfile(Profile data) async {
    final response = await client.post(
      "$baseUrl/api/profile/edit/${data.id}",
      headers: {"Content-type":"application/json"},
      body: profileToJson(data),
    );
    if(response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> deleteProfile(int id) async {
    final response = await client.delete(
      '$baseUrl/api/profile/$id',
      headers: {"content-type":"application/json"},

    );
    if(response.statusCode == 200){
      return true;
    }
    else {
      return false;
    }
  }
  

}