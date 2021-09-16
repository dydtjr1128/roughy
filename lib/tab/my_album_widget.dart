import 'dart:collection';
import 'dart:io';

import 'package:Roughy/component/album_container.dart';
import 'package:Roughy/component/roughy_app_bar.dart';
import 'package:Roughy/page/main_tabbed_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MyAlbumWidget extends StatefulWidget {
  final AlbumTabController albumTabController;

  const MyAlbumWidget({required this.albumTabController});

  @override
  _MyAlbumWidgetState createState() => _MyAlbumWidgetState(albumTabController);
}

class _MyAlbumWidgetState extends State<MyAlbumWidget> {
  final LinkedHashMap<String, AlbumContainer> albumContainers =
      LinkedHashMap<String, AlbumContainer>();


  _MyAlbumWidgetState(AlbumTabController albumTabController){
    albumTabController.initializeImages = initializeTemplates;
  }

  @override
  void initState() {
    print("_MyAlbumWidgetState initstate!!@@");
    super.initState();
    initializeTemplates();
  }

  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
        initializeTemplates();
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  void showSnackBar(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  void onAlbumSaveToPhoto(String path) async {
    print("이미지 저장 : $path");
    GallerySaver.saveImage(path).then((path) {
      showSnackBar("저장 성공!");
    });
  }

  void onAlbumDeleteFromMyAlbum(String path) async {
    print("이미지 제거 : $path");
    if (await deleteFile(path)) {
      setState(() {
        albumContainers.remove(path);
      });
      showSnackBar("삭제 성공!");
    } else {
      showSnackBar("삭제 실패");
    }
  }

  void onAlbumSelected(int index, String path, BuildContext context) async {
    print("이미지 선택 : $path $index");
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('선택'),
          children: <Widget>[
            SimpleDialogOption(
                onPressed: () {
                  onAlbumSaveToPhoto(path);
                  Navigator.pop(context);
                },
                child: const Text('사진을 사진첩에 저장')),
            SimpleDialogOption(
                onPressed: () {
                  onAlbumDeleteFromMyAlbum(path);
                  Navigator.pop(context);
                },
                child: const Text('사진을 My Album 에서 삭제')),
          ],
        );
      },
    );
  }

  void initializeTemplates() async {
    //String dir = await getApplicationSupportDirectory().
    albumContainers.clear();
    Directory directory = await getApplicationSupportDirectory();
    List<FileSystemEntity> contents = directory.listSync().toList();
    List<String> pathList = [];
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
        albumContainers[pathList[i]] = AlbumContainer(
            onTap: onAlbumSelected, containerIndex: i, path: pathList[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;

    final gridTileList = albumContainers.values
        .map((container) => GridTile(
              child: container,
            ))
        .toList();
    return Scaffold(
        appBar: RoughyAppBar(
          titleText: "MY ALBUM",
        ),
        body: GridView.count(
            crossAxisCount: 2, childAspectRatio: 0.7, children: gridTileList));
  }
}
