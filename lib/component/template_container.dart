import 'package:Roughy/data/Template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class TemplateContainer extends StatefulWidget {
  final Function onTap;
  final Function onFavoriteTap;
  final int containerIndex;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(8);
  final Template template;

  TemplateContainer(
      {required this.onTap,
      required this.containerIndex,
      required this.onFavoriteTap,
      required this.template});

  @override
  _TemplateContainerState createState() => _TemplateContainerState();
}

class _TemplateContainerState extends State<TemplateContainer> {
  late bool _isFavoriteSelected;

  @override
  Widget build(BuildContext context) {
    _isFavoriteSelected = widget.template.isFavorite;
    return Card(
      elevation: 0,
      color: const Color.fromRGBO(245, 245, 245, 1),
      //shadowColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: widget._baseBorderRadius,
        side: const BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: InkWell(
          borderRadius: widget._baseBorderRadius,
          onTap: () => widget.onTap(widget.containerIndex, context),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: widget._baseBorderRadius,
                color: Colors.transparent,
              ),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                      child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                      child: Image.asset("assets/templates/${widget.template.imageName}",
                          fit: BoxFit.contain),
                    ),
                  )),
                  Positioned(
                      left: 5.0,
                      top: 5.0,
                      child: Container(
                          //decoration: new BoxDecoration(color: Colors.red),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isFavoriteSelected = !_isFavoriteSelected;
                                  print(_isFavoriteSelected);
                                  widget.onFavoriteTap(
                                      widget.containerIndex, _isFavoriteSelected, context);
                                });
                              },
                              child: SvgPicture.asset('assets/icons/for_you.svg',
                                  color: _isFavoriteSelected
                                      ? const Color.fromRGBO(146, 196, 242, 1)
                                      : const Color.fromRGBO(217, 217, 217, 1)),
                            ),
                          ]))),
                ],
              ))),
    );
  }
}
