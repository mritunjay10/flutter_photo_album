import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_photo_album/style/theme.dart' as theme;
import 'package:flutter_photo_album/models/Album.dart';
import 'package:flutter_photo_album/models/User.dart';
import 'package:flutter_photo_album/ui/widgets/album_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_photo_album/utils/constants.dart';
import 'package:flutter_photo_album/utils/PreferenceManager.dart';
import 'package:fluttertoast/fluttertoast.dart';

BuildContext buildContext;
DateTime currentBackPressTime = DateTime.now();

class  DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashBoardState();
  }
}

class DashBoardState extends State<DashBoard> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  List<Album> list = List();
  User user;

  @override
  void initState() {
    super.initState();

    PreferenceManager
        .getUserData()
        .then((u) async{
      user = u;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return new WillPopScope(
        onWillPop: () => exitDialog(),
        child: Scaffold(
          appBar: AppBar(
              title: Text(app_name),
              backgroundColor: theme.Colors.loginGradientEnd,
              automaticallyImplyLeading: false
          ),
          body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: GridView.builder(
                gridDelegate:  new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: (){
                      onItemClick(list[index]);
                    },
                    child: AlbumView(
                      album: list[index],
                    ),
                  );
                },
              )
          ),
          bottomNavigationBar: new BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: 0, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.list),
                title: new Text('Albums'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app),
                  title: Text('Logout')
              )
            ],
          ),
        )
    );
  }

  Future<List<Album>> getAlbums() async {

    final response = await http.post(url, body: {'method': 'album_list', "user_id":user.id});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => new Album.fromJson(data))
          .toList();
    }
    else
      return list;
  }

  Future<Null> _refresh() {
    return getAlbums().then((_list) {
      setState(() => list = _list);
    });
  }

  void onTabTapped(int index) {

    if(index==1){

      showDialog(context: context,  barrierDismissible: false, builder: (BuildContext context) => logoutDialog());
    }
  }

  void logout(){

    PreferenceManager.logout().then((isClear){

      if(isClear){
        Navigator.of(context).pushNamed('/login');
      }
      else{

        Fluttertoast.showToast(
            msg: "Failed to logout",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
            backgroundColor: Colors.deepOrangeAccent,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  void onItemClick(Album album){

    print(album.photos.length);

    PreferenceManager.saveSelectedAlbum(album);

    Navigator.of(context).pushNamed('/slide');
    //print(album.albumName);
  }

  AlertDialog logoutDialog() => AlertDialog(
    title: new Text("Logout"),
    content: new Text("Sure you want to logout?"),
    actions: <Widget>[
      // usually buttons at the bottom of the dialog
      new FlatButton(
        child: new Text("Cancel"),
        onPressed: () {
          Navigator.of(buildContext).pop();
        },
      ),
      new FlatButton(
        child: new Text("Okay"),
        onPressed: () {
          logout();
        },
      ),
    ],
  );

  Future<bool> exitDialog() =>

    showDialog(
      context: buildContext,
      builder: (context)=> new AlertDialog(
        title: new Text("Exit"),
        content: new Text("Sure you want to exit?"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.of(buildContext).pop();
            },
          ),
          new FlatButton(
            child: new Text("Okay"),
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        ],
      ));
}

