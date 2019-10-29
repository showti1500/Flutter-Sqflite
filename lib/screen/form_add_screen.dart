import 'package:crudtest/ApiService.dart';
import 'package:crudtest/model/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget{

  Profile profile;
  

  FormAddScreen({Key key,this.profile}):super(key:key);
  @override
  State<StatefulWidget> createState()=>_FormAddScreen();
}

class _FormAddScreen extends State<FormAddScreen>{


  bool _isLoading =false;
  ApiService apiService;
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldAgeValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

@override
  void initState() {
    apiService=ApiService();
    if(widget.profile!=null){
      _isFieldNameValid=true;
      _controllerName.text = widget.profile.name;
      _controllerEmail.text = widget.profile.email;
      _controllerAge.text = widget.profile.age.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white,),
        title: Text(widget.profile==null?'Form Add':'Change data'),
       
      ),
      body:Builder(
        builder: (context)=>
      
      Stack(
        children: <Widget>[
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldEmail(),
                _buildTextFieldAge(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    onPressed: (){
                      if(_isFieldNameValid==null || _isFieldEmailValid==null || _isFieldAgeValid==null || !_isFieldAgeValid || !_isFieldEmailValid || !_isFieldAgeValid){
                        
                        
                        return Scaffold.of(context).showSnackBar(new SnackBar(content: Text('Please fill data!'),));
                      }
                      setState(() {
                       _isLoading = true; 
                      });
                      String name = _controllerName.text.toString();
                      String email= _controllerEmail.text.toString();
                      int age = int.parse(_controllerAge.text.toString());
                      Profile profile=Profile(name:name,email:email,age:age);
                      if(widget.profile == null){
                          apiService.createProfile(profile).then((isSuccess){
                        setState((){
                          _isLoading=false;
                        });
                        if(isSuccess){
                          Navigator.pop(context);

                        }
                        else{
                          SnackBar(content: Text('Summit data failed'),);
                        }
                      }
                      );
                      }
                      else{
                        profile.id = widget.profile.id;
                        apiService.updateProfile(profile).then((isSuccess){
                          setState(() {
                            _isLoading =false;
                          });
                          if(isSuccess){
                            Navigator.pop(context);
                          }
                          else{
                            SnackBar(content: Text('Update data failed'),);
                          }
                        });
                      }
                      //print(profile);
                    },
                    child: Text(
                      widget.profile==null?
                      'Submit'.toUpperCase():'Update'.toUpperCase(),
                      
                    ),
                    color: Colors.cyan[600],
                  ),
                ),
                
              ],
            ),
          ),
          _isLoading?Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.3,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.grey,
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ):Container(),
        ],
      ),
      ),
    );
  }
   Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Full name",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail(){
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: _isFieldEmailValid == null || _isFieldEmailValid? null : 'Email is required',
      ),
      onChanged: (value){
        bool isFieldValid = value.trim().isNotEmpty;
        if(isFieldValid != _isFieldEmailValid){
          setState(() {
           _isFieldEmailValid = isFieldValid; 
          });
        }
      },
    );
  }

    Widget _buildTextFieldAge() {
    return TextField(
      controller: _controllerAge,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Age",
        errorText: _isFieldAgeValid == null || _isFieldAgeValid
            ? null
            : "Age is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldAgeValid) {
          setState(() => _isFieldAgeValid = isFieldValid);
        }
      },
    );
  }
}


