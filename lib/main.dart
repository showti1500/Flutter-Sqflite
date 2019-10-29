import 'package:crudtest/ApiService.dart';
import 'package:crudtest/model/profile.dart';
import 'package:crudtest/screen/form_add_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ApiService().getProfiles().then((value)=>print("value:$value"));
    return MaterialApp(
      title: 'teseapi',
      home: HomeScreen(),
    );
  }


}

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomeScreen();

}

class _HomeScreen extends State<HomeScreen>{
  ApiService apiService;

  @override
  void initState(){
    super.initState();
    apiService = ApiService();
  }


  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      
      child: FutureBuilder(
        future: apiService.getProfiles(),
        builder: (BuildContext context,AsyncSnapshot<List<Profile>> snapshot){
          if(snapshot.hasError){
            return _buildNullReturn(snapshot.error.toString());
            // return Center(
            //   child: Text('Something wrong with message:${snapshot.error.toString()}'),
            // );
          }
          else if(snapshot.connectionState == ConnectionState.done){
            List<Profile> profiles = snapshot.data;
            return _buildListView(profiles);
          }
          else{
            return Scaffold(
              appBar:AppBar(
                title: Text('API CRUD'),
              ),
              body:Column(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Center(child: CircularProgressIndicator(
             
              backgroundColor:Colors.amber ,
            ),
            ),
            Text('Loading...')
              ],),
              
              );
          }
            
          
        },
      ),
    );
  }

  Widget _buildNullReturn(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Test'),
      ),
      body: Center(
        child: Text(
          '$title'+'It is something wrong',
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }

  Widget _buildListView(List<Profile> profiles){
    return Scaffold(
     appBar: AppBar(
       title: Text('CRUD APP'),
       actions: <Widget>[
         GestureDetector(
           onTap: (){
             Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>FormAddScreen()));
           },
           child: Padding(
             padding: const EdgeInsets.only(right: 16.0),
             child: Icon(Icons.add,
             color: Colors.white, ),
           ),
         ),
         
       ],
       
       
     ),
     body: Builder(builder: (context)=>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context,index){
          Profile profile = profiles[index];
          return Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.name,
                      style:Theme.of(context).textTheme.title,
                    ),
                    Text(profile.email),
                    Text(profile.age.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: (){
                            //Scaffold.of(context).showSnackBar(new SnackBar(content: Text('Delete!'),));
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text('Warning'),
                                  content: Text('Are you sure want to delete profile ${profile.name}?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: (){
                                        
                                        apiService.deleteProfile(profile.id).then((isSuccess){
                                          if(isSuccess){
                                            setState(() {
                                              
                                            });
                                            SnackBar(content: Text('Deleted!'),);
                                            
                                          }
                                          else{
                                            SnackBar(content: Text('Delete data failed!'),);
                                          }
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>FormAddScreen(profile: profile,)
                            ));
                          },
                          child: Text(
                            'Edit',
                            style:TextStyle(color:Colors.blue),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: profiles.length,
      ),
      
    ),
     ),
    );
  }


}


