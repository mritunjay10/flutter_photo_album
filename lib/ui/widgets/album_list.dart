import 'package:flutter/material.dart';
import 'package:flutter_photo_album/utils/constants.dart';
import 'package:flutter_photo_album/style/theme.dart' as Theme;
import 'package:flutter_photo_album/ui/widgets/album_view.dart';
import 'package:flutter_photo_album/models/Album.dart';

class AlbumList extends StatefulWidget{

  final List<Album> albums;

  const AlbumList({Key key, this.albums}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AlbumListState(albums);
  }
}

class _AlbumListState extends State<AlbumList>{

  final List<Album> albums;


  _AlbumListState(this.albums);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
        onWillPop: () => Future.value(false),
        child: getScaffold()
    );
  }

  Scaffold getScaffold(){

    return new Scaffold(
      appBar: new AppBar(
        title: Text(app_name),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.Colors.loginGradientEnd,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 4 / 3,
                controller: ScrollController(keepScrollOffset: false),
                scrollDirection: Axis.vertical,
                children: albums.map(
                      (Album album) {
                    return new GestureDetector(
                      onTap: (){
                        onItemClick(album);
                      },
                      child: AlbumView(
                        album: album,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onItemClick(Album album){

    Navigator.of(context).pushNamed('/slide');
    //print(album.albumName);
  }
}

