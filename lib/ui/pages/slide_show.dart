import 'package:flutter/material.dart';
import 'package:flutter_photo_album/style/theme.dart' as theme;
import 'dart:async';
import 'package:flutter_photo_album/utils/constants.dart';
import 'package:flutter_photo_album/models/Photo.dart';
import 'package:flutter_photo_album/models/Album.dart';
import 'package:flutter_photo_album/utils/PreferenceManager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

int totalSize;
BuildContext buildContext;
Album albumData;
bool downloading = false;
var progressString = "";

class Slideshow extends StatefulWidget {
  @override
  _SlideshowState createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {

  List<Photo> photos = new List();
  final PageController controller = PageController(viewportFraction: 0.8);

  Stream slides;
  int currentPage = 0;
  bool  isLoading = false;

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData(){

    setState(() {
      isLoading = false;
    });

    PreferenceManager
        .getSelectedAlbum()
        .then((album){
          albumData = album;
          photos.addAll(album.photos);
          totalSize = photos.length;

          if(photos.length>0){

            setState(() {
              isLoading = true;
            });
          }

          controller.addListener(() {
            int next = controller.page.round();
            if (currentPage != next) {
              setState(() {
                currentPage = next;
              });
            }
          });
    });

  }

  AnimatedContainer _buildStoryPage(Photo data, bool active) {
    // Animated properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 50 : 80;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(data.photoPath),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: blur,
            offset: Offset(offset, offset),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      appBar: AppBar(
          title: Text(app_name),
          backgroundColor: theme.Colors.loginGradientEnd
      ),
      body: StreamBuilder(
        stream: slides,
        initialData: [],
        builder: (context, AsyncSnapshot snap) {
          // List slideList = snap.data.toList();
          return PageView.builder(
            controller: controller,
            itemCount: photos.length,
            itemBuilder: (context, int currentIndex) {
              bool active = currentIndex == currentPage;
              return _buildStoryPage(photos[currentIndex], active);
            },
          );
        },
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: 1, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.skip_previous),
            title: new Text('Previous'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.file_download),
            title: new Text('Download'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.skip_next),
              title: Text('Next')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {

    if(index==0){

      controller.animateToPage(currentPage-1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease);
    }
    else if(index==2){

      controller.animateToPage(currentPage+1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease);
    }
    else{
      showDialog(context: context,  barrierDismissible: false, builder: (BuildContext context) =>
      downLoadDialog("Download Album", "Download all the images from the album?", "Okay"));}
    }
  }

  void startDownload(filename) async{

    getExternalStorageDirectory().then((directory){

      print(zip_url+"$filename");

      final taskId = FlutterDownloader.enqueue(
        url: zip_url+"$filename",
        savedDir: directory.path,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    });

    showDialog(context: buildContext,  barrierDismissible: false, builder: (BuildContext context) => downLoadAlert());

  }

  void getDownloadableLink(){

    showDialog(context: buildContext, builder: (BuildContext context) => progressDialog);

    getZipLink().then((onValue){

      if(onValue.length>0){
        print(onValue);
        Navigator.of(buildContext).pop();

        showDialog(context: buildContext, barrierDismissible: false, builder: (BuildContext context) => downLoadStartDialog(onValue));
      }
      else{
        showDialog(context: buildContext, barrierDismissible: false, builder: (BuildContext context) =>
            downLoadDialog("Falied!", "Retry download all the images from the album?","Retry")
        );
      }
    }).catchError((error){

      showDialog(context: buildContext, barrierDismissible: false, builder: (BuildContext context) =>
          downLoadDialog("Falied!", "Retry download all the images from the album?","Retry")
      );
    });
  }

  Future<String> getZipLink() async {

    final response = await http.post(url, body: {'method': 'album_download', "album":albumData.id});
    if(response.statusCode == 200){

      return response.body;
    }
    else {
      return "";
    }
  }


  AlertDialog downLoadDialog(title, content, text) => AlertDialog(
    title: new Text(title),
    content: new Text(content),
    actions: <Widget>[
      // usually buttons at the bottom of the dialog
      new FlatButton(
        child: new Text("Cancel"),
        onPressed: () {
          Navigator.of(buildContext).pop();
        },
      ),
      new FlatButton(
        child: new Text(text),
        onPressed: () {
          Navigator.of(buildContext).pop();
          getDownloadableLink();
        },
      ),
    ],
  );

  AlertDialog downLoadStartDialog(filename) => AlertDialog(
    title: new Text("Download"),
    content: new Text("Press okay to download album "),
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
          Navigator.of(buildContext).pop();
          startDownload(filename);
        },
      ),
    ],
  );

  AlertDialog downLoadAlert() => AlertDialog(
    title: new Text("Downloading"),
    content: new Text("Check your notification for download status. And after download please extract the folder and relive your memories."),
    actions: <Widget>[
      // usually buttons at the bottom of the dialog
      new FlatButton(
        child: new Text("Got it!"),
        onPressed: () {
          Navigator.of(buildContext).pop();
        },
      ),
    ],
  );

  AlertDialog progressDialog = new AlertDialog(
    contentPadding: EdgeInsets.all(0.0),
    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
    content: new Container(
      decoration: new BoxDecoration(
          color: Colors.orange[300],
          borderRadius: new BorderRadius.circular(10.0)
      ),
      width: 300.0,
      height: 200.0,
      alignment: AlignmentDirectional.center,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Theme
            (data: ThemeData(accentColor: Colors.deepOrangeAccent
          ),
              child: new Center(
                child: new SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
              )
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: new Center(
              child: new Text(
                "Fetching downloadable link...",
                style: new TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
