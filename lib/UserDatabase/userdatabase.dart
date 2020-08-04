import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meta/meta.dart';
import 'package:todos/Screens/Home/home.dart';
import 'package:todos/Theme/theme.dart';

class UserDatabase{
  String userID;
  bool theme;
  UserDatabase({@required this.userID,@required this.theme});

  Future<void> setUserData(String name,String todo,String time) async {
    return await Firestore.instance.collection(userID).document().setData({
      'todoName': name,
      'todoDetails': todo,
      'time':time
    });
  }

  Future<void> updateUserData(String name,String todo,String time,String docID) async {
    return await
    Firestore.instance
        .collection(userID)
        .document(docID)
        .updateData({
          'todoName': name,
          'todoDetails': todo,
          'time':time
        }).then((result){
          print('Updated');
        }).catchError((onError){
          print("Some Error Occurred");
        });
  }

  final CollectionReference profileDetails = Firestore.instance.collection('User-Profile');

  Future<void> updateUserProfile(String name,String email,String mobile) async {
    return await profileDetails.document(userID).setData({
      'Name':name,
      'Email':email,
      'Mobile':mobile,
    }).whenComplete(() => {
      print('ProfileUpdated')
    });
  }

  Future<Map> getUserProfile() async{
    Map<dynamic,dynamic> userData;
    await profileDetails.document(userID).get().then((value){
      userData=value.data;
    });
    if(userData!=null){
      return userData;
    }else{
      return{
        'Name':'null',
        'Email':'null',
        'Mobile':'null',
      };
    }
  }
  StreamBuilder<QuerySnapshot> get userData{
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(userID).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.data.documents.length == 0) {
          return Center(
            child: Text('No Scheduled ToDos',style:
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
        return Container(
          padding: EdgeInsets.fromLTRB(0,0,0,0),
          child: ListView.separated(
            separatorBuilder:(context,int){
              return Divider(
                height: 1,
                thickness: 0.7,
                color: theme?LightTheme.textColor:Colors.grey,
                indent: 15,
                endIndent:15,
              );
            },
            itemCount: snapshot.data.documents.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (context,index){
              return Slidable(
                  actionPane:SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      foregroundColor:LightTheme.textColor,
                      caption: 'Edit',
                      color: Colors.lightGreen,
                      icon: Icons.edit,
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (_) =>TodoForm(
                                todo:TextEditingController(text: snapshot.data.documents[index]['todoName'],),
                                todoDetails:TextEditingController(text: snapshot.data.documents[index]['todoDetails']),
                                time: TimeOfDay(
                                  hour:int.parse('${snapshot.data.documents[index]['time'].substring(10,12)}'),
                                  minute:int.parse('${snapshot.data.documents[index]['time'].substring(13,15)}'),
                                ),
                                updateOrPost: true,
                                docID:snapshot.data.documents[index].documentID
                            )
                        );
                      },
                    ),
                    IconSlideAction(
                      foregroundColor:LightTheme.textColor,
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => Firestore.instance.collection(userID).document(snapshot.data.documents[index].documentID).delete(),
                    ),
                  ],
                  key: Key(snapshot.data.documents[index].documentID),
                  child:Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      minHeight: 60,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              snapshot.data.documents[index]['todoName'],
                              style: TextStyle(
                                letterSpacing: 0.8,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: theme?LightTheme.textColor:DarkTheme.textColor,
                              ),
                            ),
                            snapshot.data.documents[index]['todoDetails']!=null?SizedBox(height: 8,):SizedBox(height: 0,),
                            snapshot.data.documents[index]['todoDetails']!=null?
                            Container(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              width: 220,
                              child: Text(snapshot.data.documents[index]['todoDetails'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: theme?LightTheme.textColor:DarkTheme.textColor,
                                ),
                              ),
                            ):SizedBox(height: 0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              size: 12,
                              color: theme?LightTheme.textColor:DarkTheme.textColor,
                            ),
                            SizedBox(width: 4,),
                            Text(snapshot.data.documents[index]['time'],
                              style: TextStyle(
                                color: theme?LightTheme.textColor:DarkTheme.textColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                );
              },
          ),
        );
      }
    );
  }
}
