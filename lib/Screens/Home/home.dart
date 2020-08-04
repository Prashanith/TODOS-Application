import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todos/Auth-BLoC/authbloc.dart';
import 'package:todos/Auth-BLoC/authevents.dart';
import 'package:todos/Theme/theme.dart';
import 'package:todos/Theme/themebloc.dart';
import 'package:todos/Theme/themeevent.dart';
import 'package:todos/Theme/themestate.dart';
import 'package:todos/UserDatabase/userdatabase.dart';

var userID=FlutterSecureStorage();

class AppTheme{
  bool activeTheme=false;
}

class Home extends StatefulWidget {
  final String uid;
  const Home({Key key, this.uid}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  int _selectedIndex = 0;

  static List<Widget> widgets=[
    Todo(),
    WorkOut(),
    ProfileForm(),
    Settings(),
  ];

  createDataStore()async{
    String token =await userID.read(key: 'userIDToken');
    Firestore.instance.collection(token);
    print('User Database Created');
  }

  setToken() async {
    await userID.write(key:'userIDToken', value:widget.uid);
  }

  @override
  void initState() {
    setToken();
    createDataStore();
    super.initState();
  }

  void _onItemTapped(int index)=>setState(()=>_selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeState>(
        builder: (context,state){
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Todo's",
                  style: TextStyle(
                      color:state.props[0]?LightTheme.titleColor:DarkTheme.titleColor
                  ),
                ),
                backgroundColor:state.props[0]?LightTheme.appBarColor:DarkTheme.appBarColor,
              ),
              backgroundColor: state.props[0]?LightTheme.backGroundColor:DarkTheme.backGroundColor,
              body:widgets[_selectedIndex],
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                  elevation: 10,
                  backgroundColor:state.props[0]?LightTheme.floatingActionButton:DarkTheme.floatingActionButton,
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (_) =>TodoForm(
                        todo: null,
                        todoDetails: null,
                        time: null,
                        updateOrPost: false,
                        docID: null,
                      ),
                    );
                  },
                  child: Tooltip(
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black38,
                          width: 1.0,
                        )
                    ),
                    showDuration: Duration(seconds: 1),
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800]
                    ),
                    message: 'Add TODO',
                    child:Icon(
                      Icons.add,
                      size: 25,
                    ),
                  )
              ),
              bottomNavigationBar:SizedBox(
                height: 60,
                child: BottomNavigationBar(
                  backgroundColor:state.props[0]?LightTheme.bottomNavBar:DarkTheme.bottomNavBar,
                  iconSize: 28,
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  showSelectedLabels: true,
                  elevation:25,
                  selectedItemColor:state.props[0]?LightTheme.bottomNavBarActiveIcons:DarkTheme.bottomNavBarActiveIcons,
                  unselectedItemColor:state.props[0]?LightTheme.bottomNavBarInActiveIcons:DarkTheme.bottomNavBarInActiveIcons,
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.timer),
                      title: Text('TODO'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.directions_run),
                      title: Text('Exercises'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Text('Profile'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              )
          );
        }
    );
  }
}

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo>{
  String token ;
  bool checkData=false;

  void setToken()async{
    String readToken=await userID.read(key: 'userIDToken');
    setState((){
      this.token=readToken;
      this.checkData=true;
    });
  }

  @override
  void initState() {
    setToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return BlocBuilder<ThemeBloc,ThemeState>(
      builder:(context,state){
        return !checkData?Center(child: CircularProgressIndicator(),):
        UserDatabase(userID: token,theme:state.props[0]).userData;
      },
    );
  }
}

class WorkOut extends StatefulWidget {
  @override
  _WorkOutState createState() => _WorkOutState();
}

class _WorkOutState extends State<WorkOut> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeState>(
        builder:(context,state){
          return Center(
            child:Text('Application Not Ready',
              style:
              TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.5,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
                fontWeight: FontWeight.w300,
                color: Colors.grey[500],
                fontSize: 20,
              ),
            ),
          );
        }
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeState>(
        builder:(context,state){
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              ListTile(
                title: Text('Theme',
                  style:TextStyle(
                    color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                  ),
                ),
                subtitle:state.props[0]?
                Text('Light Theme Active',
                  style:TextStyle(
                  color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                  ),
                ):
                Text('Dark Theme Active',
                  style:TextStyle(
                  color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                  ),
                ),
                trailing:Container(
                  width: 50,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        if(state.props[0]){
                          BlocProvider.of<ThemeBloc>(context).add(SetDarkTheme());
                        }
                        else if(!state.props[0]){
                          BlocProvider.of<ThemeBloc>(context).add(SetLightTheme());
                        }
                        print(state.props[0]);
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        AnimatedContainer(
                            decoration: BoxDecoration(
                              color:state.props[0]?LightTheme.toggleColor:DarkTheme.toggleColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.all(0),
                            width: 45,
                            height: 20,
                            duration:Duration(milliseconds: 100),
                            child:Stack(
                              children: <Widget>[
                                AnimatedPositioned(
                                  duration: Duration(milliseconds: 100),
                                  top: 0,
                                  left:!state.props[0]?25:0,
                                  right:!state.props[0]?0:25,
                                  bottom: 0,
                                  child: AnimatedSwitcher(
                                    duration: Duration(seconds: 1),
                                    switchInCurve: Curves.easeInCirc,
                                    switchOutCurve: Curves.easeInCirc,
                                    reverseDuration: Duration(milliseconds:200),
                                    child: Icon(
                                        Icons.brightness_1,
                                        size: 20,
                                        color:state.props[0]?LightTheme.toggleIconColor:DarkTheme.toggleIconColor
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ) ,
              ),
              Divider(
                height: 1,
                thickness:0.7,
                color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                indent: 15,
                endIndent:15,
              ),
              GestureDetector(
                onTap: (){
                  print('hello');
                  showDialog(
                    context:context,
                    builder: (_)=>AlertDialog(
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        color: state.props[0]?LightTheme.textColor:DarkTheme.textColor
                      ),
                      contentTextStyle: TextStyle(
                          fontSize: 15,
                          color: state.props[0]?LightTheme.textColor:DarkTheme.textColor
                      ),
                      backgroundColor: state.props[0]?LightTheme.backGroundColor:Colors.blueGrey[900],
                      title: Text('log-out alert'),
                      scrollable: false,
                      shape: RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(5),
                      ),
                      content: Text('are you sure ?'),
                      actions: <Widget>[
                        OutlineButton(
                          onPressed: (){
                            Navigator.pop(context, true);
                            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
                          },
                          textTheme: ButtonTextTheme.accent,
                          child: Text('YES',
                            style: TextStyle(
                                fontSize: 15,
                                color: state.props[0]?LightTheme.textColor:DarkTheme.textColor
                            ),
                          ),
                        ),
                        SizedBox(width:10,),
                        OutlineButton(
                          onPressed: ()=>Navigator.pop(context, true),
                          child: Text('NO',
                            style: TextStyle(
                                fontSize: 15,
                                color: state.props[0]?LightTheme.textColor:DarkTheme.textColor
                            ),
                          ),
                        ),
                      ],
                      
                    ),
                  );
                },
                child: ListTile(
                  selected: true,
                  title:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.exit_to_app,
                        color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                      ),
                      SizedBox(width: 10,),
                      Text('Log Out',
                        style:TextStyle(
                          color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  bool checkState=false;
  var response;
  bool check =false;
  var name=TextEditingController();
  var email=TextEditingController();
  var mobile=TextEditingController();
  final _formKey=GlobalKey<FormState>();

  void getProfileData()async{
    String token=await userID.read(key:'userIDToken');
    Map<dynamic,dynamic> data=await UserDatabase(userID:token).getUserProfile();
    setState(() {
      this.name.text=data['Name'];
      this.email.text=data['Email'];
      this.mobile.text=data['Mobile'];
      this.checkState=true;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeState>(
      builder: (context,state){
        return !checkState?Center(
            child:SpinKitFadingCircle(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color:state.props[0]?LightTheme.loadingIcon:DarkTheme.loadingIcon,
                  ),
                );
              },
            )
        ):
        ListView(
          padding:EdgeInsets.fromLTRB(25,30,25,0),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Profile',
                  style:TextStyle(
                      color:state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                      fontSize: 20
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Theme(
                      data: ThemeData(
                        cardColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        primaryColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        primaryColorDark:state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                      ),
                      child: TextFormField(
                        onEditingComplete: ()=>_formKey.currentState.validate(),
                        onChanged: (name){
                          _formKey.currentState.validate();
                        },
                        validator: (name){
                          if(name.isEmpty){
                            return 'username cannot be empty';
                          }
                          else
                            return null;
                        },
                        keyboardType:TextInputType.text,
                        cursorColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        style: TextStyle(
                          color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        ),
                        decoration: InputDecoration(labelText: 'name',
                          filled: true,
                          fillColor:state.props[0]?Colors.grey[100]:Colors.black38,
                          enabledBorder:  OutlineInputBorder(
                              borderSide:BorderSide(
                                color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                              ),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          border: OutlineInputBorder(
                              borderSide:BorderSide(
                                color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                              ),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelStyle: TextStyle(
                            color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          ),
                        ),
                        controller: name,
                      ),
                    ),
                    SizedBox(height:20,),
                    Theme(
                      data: ThemeData(
                        cardColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        primaryColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        primaryColorDark: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                      ),
                      child: TextFormField(
                        onEditingComplete: ()=>_formKey.currentState.validate(),
                        onChanged: (email){
                          _formKey.currentState.validate();
                        },
                        validator: (email){
                          if(email.isEmpty){
                            return 'username cannot be empty';
                          }
                          if(!EmailValidator.validate(email)){
                            return 'Email Address not provided';
                          }
                          else
                            return null;
                        },
                        keyboardType:TextInputType.emailAddress,
                        cursorColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        style: TextStyle(
                          color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        ),
                        decoration: InputDecoration(labelText: 'e-mail',
                          filled: true,
                          fillColor: state.props[0]?Colors.grey[100]:Colors.black38,
                          enabledBorder:OutlineInputBorder(
                              borderSide:BorderSide(
                                color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                              ),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          border:OutlineInputBorder(
                              borderSide:BorderSide(
                                color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                              ),
                              borderRadius:BorderRadius.circular(8)
                          ),
                          labelStyle: TextStyle(
                            color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          ),
                        ),
                        controller: email,
                      ),
                    ),
                    SizedBox(height:20,),
                    Theme(
                      data: ThemeData(
                        cardColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        primaryColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        primaryColorDark: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                      ),
                      child: TextFormField(
                        onEditingComplete: ()=>_formKey.currentState.validate(),
                        onChanged: (mobile){
                          _formKey.currentState.validate();
                        },
                        validator: (mobile){
                          if(mobile.isEmpty){
                            return 'username cannot be empty';
                          }
                          if(!EmailValidator.validate(mobile)){
                            return 'Email Address not provided';
                          }
                          else
                            return null;
                        },
                        keyboardType:TextInputType.number,
                        cursorColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        style: TextStyle(
                          color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'mobile',
                          filled: true,
                          fillColor: state.props[0]?Colors.grey[100]:Colors.black38,
                          enabledBorder:OutlineInputBorder(
                            borderSide:BorderSide(
                              color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                            ),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          border: OutlineInputBorder(
                              borderSide:BorderSide(
                                color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                              ),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          labelStyle: TextStyle(
                            color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          ),
                        ),
                        controller: mobile,
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: 50,),
            FlatButton(
                shape: RoundedRectangleBorder(side: BorderSide(
                    width: 0.1,
                    color: Colors.white,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(25)),
                color:state.props[0]?LightTheme.buttonColor:DarkTheme.buttonColor,
                onPressed:()async {
                  String token=await userID.read(key:'userIDToken');
                  await UserDatabase(userID:token, theme:state.props[0]).updateUserProfile(
                    name.text,
                    email.text,
                    mobile.text,
                  );
                  getProfileData();
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Profile Updated',style: TextStyle(color: Colors.greenAccent),))
                  );
                },
                child:Text('Update Profile',
                  style: TextStyle(
                      color: Colors.white
                  ),
                )
            ),
          ],
        );
      },
    );
  }
}

class TodoForm extends StatefulWidget {
  final TextEditingController todo;
  final TextEditingController todoDetails;
  final TimeOfDay time;
  final bool updateOrPost;
  final String docID;

  //updateOrPost argument takes the value true for updateRequest
  //for post request it takes false

  TodoForm({@required this.todo,@required this.todoDetails,@required this.time,@required this.updateOrPost,@required this.docID});

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  var todo=TextEditingController();
  var todoDetails=TextEditingController();
  TimeOfDay time;

  String changeTimeFormat(TimeOfDay time){
    int hour,minute;
    String period,finalTime;
    hour=time.hour;
    minute=time.minute;

    // this condition sets up the period for the time
    if(time.hour>=0&&(time.hour)<=11){
      period='AM';
    }
    else{
      period='PM';
    }

    //since time is stored in her in 12 hr format this is an exception
    //so when time is 00:00 AM we set 12:00AM in 12hr
    if(time.hour==0){
      hour=12;
      period='AM';
    }

    //this condition changes 24 hour format to 12 hour
    if(period=='AM'){}else if(period=='PM'&&(hour>12)){
      hour=hour-12;
    }

    finalTime='${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}$period';
    print(finalTime);
    return finalTime;
  }

  void _pickTime() async{
    TimeOfDay timePicked= await showTimePicker(
      context: context,
      initialTime:time,
      useRootNavigator: true,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                height: 400,
                width: 400,
                child: child,
              ),
            ),
          ],
        );
      },
    );
    if(timePicked!=null){
      setState(() {
        time = timePicked;
      });
    }
  }

  @override
  void initState() {
    time=TimeOfDay.now();
    if(widget.updateOrPost){
      todoDetails=widget.todoDetails;
      todo=widget.todo;
      time=widget.time;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeState>(
        builder:(context,state){
          return SimpleDialog(
            backgroundColor: state.props[0]?LightTheme.backGroundColor:Colors.blueGrey[900],
            title: Text('TODO',
                style: TextStyle(
                  color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                ),
            ),
            contentPadding: EdgeInsets.fromLTRB(10,10,10,0),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0,
                ),
                borderRadius:BorderRadius.circular(10)
            ),
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.fromLTRB(15,10,10,0),
                  height: 265,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Theme(
                        data: ThemeData(
                          cardColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          primaryColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          primaryColorDark: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        ),
                        child: TextFormField(
                          controller: todo,
                          keyboardType:TextInputType.text,
                          cursorColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          style: TextStyle(
                            color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: "todo-name",
                            hintStyle: TextStyle(
                              color:state.props[0]?LightTheme.hintText:DarkTheme.hintText,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height:15,),
                      Theme(
                        data: ThemeData(
                          cardColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          primaryColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          primaryColorDark: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                        ),
                        child: TextField(
                          controller: todoDetails,
                          keyboardType:TextInputType.text,
                          cursorColor: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          style: TextStyle(
                            color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          ),
                          decoration:InputDecoration.collapsed(
                            hintText: "todo-details",
                            hintStyle: TextStyle(
                              color:state.props[0]?LightTheme.hintText:DarkTheme.hintText,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      ListTile(
                        contentPadding: EdgeInsets.fromLTRB(5,0,5,0),
                        dense: true,
                        trailing: IconButton(
                          icon:Icon(
                              Icons.arrow_drop_down,
                            color: state.props[0]?LightTheme.textColor:DarkTheme.textColor,
                          ),
                          onPressed: ()=>_pickTime(),
                        ),
                        title: Text('${time.format(context)}',
                          style: TextStyle(
                            color: state.props[0]?LightTheme.textColor:DarkTheme.textColor
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 5,),
                          RaisedButton(
                              shape: RoundedRectangleBorder(side: BorderSide(
                                  width: 0.1,
                                  color: Colors.white,
                                  style: BorderStyle.solid
                              ), borderRadius: BorderRadius.circular(10)
                              ),
                              color: state.props[0]?LightTheme.buttonColor:DarkTheme.buttonColor,
                              onPressed:()async{
                                String token=await userID.read(key:'userIDToken');
                                if(widget.docID==null&&widget.updateOrPost==false){
                                  await UserDatabase(userID:token,theme: state.props[0]).setUserData(todo.text, todoDetails.text,changeTimeFormat(time));
                                }
                                else if(widget.docID!=null&&widget.updateOrPost==true){
                                  await UserDatabase(userID:token,theme: state.props[0]).updateUserData(todo.text, todoDetails.text, changeTimeFormat(time),widget.docID);
                                }
                                Navigator.pop(context, true);
                              },
                              child:widget.updateOrPost?Text('Update',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ):Text('Add TODO',
                                style: TextStyle(
                                    color:Colors.white,
                                ),
                              )
                          ),
                          SizedBox(width: 15,),
                          RaisedButton(
                              shape: RoundedRectangleBorder(side: BorderSide(
                                  width: 0.1,
                                  color: Colors.white,
                                  style: BorderStyle.solid
                              ), borderRadius: BorderRadius.circular(10)
                              ),
                              color: state.props[0]?LightTheme.buttonColor:DarkTheme.buttonColor,
                              onPressed:(){
                                setState(() {
                                  time=TimeOfDay.now();
                                  todoDetails.clear();
                                  todo.clear();
                                });
                              },
                              child:Text('Reset',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                          )
                        ],
                      )
                    ],
                  )
              )
            ],
          );
        }
    );
  }
}


