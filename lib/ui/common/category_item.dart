import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/database/database.dart';
import 'package:todo/utils/category.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/styleguide.dart';

class CategoryItem extends StatelessWidget {

  final CategoryWithCount categoryWithCount;

  CategoryItem({this.categoryWithCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: (){},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 64,
                width: 64,
                margin: EdgeInsets.only(top: 32, bottom: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getCategoryColor(categoryWithCount.category.id).withOpacity(0.36)
                ),
                child: Center(
                  child: SvgPicture.asset(
                    getCategoryImage(categoryWithCount.category.id),
                  ),
                ),
              ),
              Text(
                localisedString(context, '${categoryWithCount.category.description}'),
                style: categoryTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${categoryWithCount.count} ${localisedString(context, 'tasks')}",
                style: subCategoryTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
