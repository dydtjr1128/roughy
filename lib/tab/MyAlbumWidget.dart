import 'dart:collection';
import 'dart:io';

import 'package:Roughy/component/albumContainer.dart';
import 'package:Roughy/component/roughyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MyAlbumWidget extends StatefulWidget {
  @override
  _MyAlbumWidgetState createState() => _MyAlbumWidgetState();
}

class _MyAlbumWidgetState extends State<MyAlbumWidget> {
  final LinkedHashMap<String, AlbumContainer> albumContainers =
      LinkedHashMap<String, AlbumContainer>();

  @override
  void initState() {
    super.initState();
    initializeTemplates();
  }

  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  showSnackBar(String text) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  onAlbumSaveToPhoto(String path) async {
    print("이미지 저장 : " + path.toString());
    GallerySaver.saveImage(path).then((path) {
      showSnackBar("저장 성공!");
    });
  }

  onAlbumDeleteFromMyAlbum(String path) async {
    print("이미지 제거 : " + path.toString());
    if (await deleteFile(path)) {
      setState(() {
        albumContainers.remove(path);
      });
      showSnackBar("삭제 성공!");
    } else {
      showSnackBar("삭제 실패");
    }
  }

  onAlbumSelected(int index, String path, BuildContext context) async {
    print("이미지 선택 : " + path.toString() + " " + index.toString());
    await showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('선택'),
        children: <Widget>[
          SimpleDialogOption(
              child: Text('사진을 사진첩에 저장'),
              onPressed: () {
                onAlbumSaveToPhoto(path);
                Navigator.pop(context);
              }),
          SimpleDialogOption(
              child: Text('사진을 My Album 에서 삭제'),
              onPressed: () {
                onAlbumDeleteFromMyAlbum(path);
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  void initializeTemplates() async {
    //String dir = await getApplicationSupportDirectory().
    Directory directory = await getApplicationSupportDirectory();
    List<FileSystemEntity> contents = directory.listSync().toList();
    List<String> pathList = List();
    print(contents.length.toString() + "개 입니다.");
    for (int i = 0; i < contents.length; i++) {
      FileSystemEntityType type = FileSystemEntity.typeSync(contents[i].path);
      final extension = path.extension(contents[i].path).toLowerCase();
      if (type == FileSystemEntityType.file && extension == ".png") {
        precacheImage(FileImage(File(contents[i].path)), context);
        pathList.add(contents[i].path);
      }
    }
    pathList.sort((a, b) => a.compareTo(b));
    pathList = pathList.reversed.toList();

    setState(() {
      for (int i = 0; i < pathList.length; i++) {
        albumContainers[pathList[i]] =
            new AlbumContainer(onTap: onAlbumSelected, containerIndex: i, path: pathList[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;

    var gridTileList = albumContainers.values
        .map((container) => new GridTile(
              child: container,
            ))
        .toList();
    return Scaffold(
        appBar: RoughyAppBar(onClickedCallback: (bool isSelected) {}),
        body: GridView.count(
            crossAxisCount: 2, childAspectRatio: (itemWidth / itemHeight), children: gridTileList));
  }

/*@override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    int i = 0;
    return Scaffold(
        appBar: RoughyAppBar(onClickedCallback: (bool isSelected) {}),
        body: new FutureBuilder(
          future: initializeTemplates(),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            List<AlbumContainer> albumContainers = List();
            if (snapshot.hasData) {
              for (String path in snapshot.data)
                albumContainers.add(
                    new AlbumContainer(onTap: onAlbumSelected, containerIndex: i++, path: path));
            }
            return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (itemWidth / itemHeight),
                children: albumContainers);
          },
        ));
  }*/
}
