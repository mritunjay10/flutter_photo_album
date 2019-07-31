import 'package:flutter/material.dart';
import 'package:flutter_photo_album/models/Album.dart';


class AlbumView extends StatelessWidget {

  final Album album;

  const AlbumView({Key key, this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(

      child: Stack(

          children: <Widget>[
           /* Image.network(
              album.albumCover,
              fit: BoxFit.cover,
            ),*/
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    image: new NetworkImage(
                      album.albumCover,
                    ),
                  )),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0,70.0,0,0),
                child : Center(
                  child: new Text(
                    album.albumName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize:  18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                    maxLines: 1,
                  ),
                )
            ),
          ],
      ),
    );
  }
}