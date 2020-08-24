import 'package:flutter/material.dart';
import 'package:todo/database/database.dart';
import 'package:todo/utils/category.dart';
import 'package:todo/utils/styleguide.dart';

class ItemCategory extends StatefulWidget {
  final Category category;
  final Function changePos;
  final int pos;
  ItemCategory({this.category, this.changePos, this.pos});

  @override
  _ItemCategoryState createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<ItemCategory>
    with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _dotHeightAnimation;
  Animation<double> _dotWidthAnimation;
  Animation<double> _dotLeftPositionedAnimation;
  Animation<double> _dotTopPositionedAnimation;
  Animation<double> _textLeftPaddingAnimation;
  Animation<double> _elevationAnimation;
  Animation<Color> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _dotHeightAnimation =
        Tween<double>(begin: 10, end: 40).animate(_controller);
    _dotWidthAnimation =
        Tween<double>(begin: 10, end: 120).animate(_controller);
    _dotLeftPositionedAnimation =
        Tween<double>(begin: 8, end: 0).animate(_controller);
    _dotTopPositionedAnimation =
        Tween<double>(begin: 12, end: 0).animate(_controller);
    _textColorAnimation =
        ColorTween(begin: Color(0xFF8E8E8E), end: Colors.white)
            .animate(_controller);
    _textLeftPaddingAnimation =
        Tween<double>(begin: 4, end: 0).animate(_controller);
    _elevationAnimation = Tween<double>(begin: 0, end: 4).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pos == widget.category.id) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return StatefulBuilder(
      builder: (context, state) {
        return AnimatedBuilder(
          builder: (context, child) {
            return Card(
              elevation: _elevationAnimation.value,
              child: InkWell(
                onTap: () {
                  state(() {
                    widget.changePos(widget.category.id);
                  });
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: _dotLeftPositionedAnimation.value,
                        top: _dotTopPositionedAnimation.value,
                        child: Container(
                          height: _dotHeightAnimation.value,
                          width: _dotWidthAnimation.value,
                          decoration: BoxDecoration(
                              color: getCategoryColor(widget.category.id),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(5),),
                          ),
                        ),
                      ),
                      Align(
                        widthFactor: 1.0,
                        alignment: Alignment.center,
                        child: Container(
                          width: 120,
                          padding: EdgeInsets.only(
                            left: _textLeftPaddingAnimation.value,
                          ),
                          child: Text(
                            widget.category.description,
                            textAlign: TextAlign.center,
                            style: categoryTitleTextStyle.copyWith(
                                color: _textColorAnimation.value),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          animation: _controller,
        );
      },
    );
  }
}
