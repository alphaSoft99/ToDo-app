import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/blocs/bloc.dart';
import 'package:todo/database/database.dart';
import 'package:todo/ui/task/category_page.dart';
import 'package:todo/utils/category.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/style_guide.dart';

class CategoryItem extends StatelessWidget {

  final CategoryWithCount categoryWithCount;
  final List<Category> categories;
  final TodoAppBloc bloc;

  CategoryItem({this.categoryWithCount, this.categories,this.bloc});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(category: categoryWithCount.category, categories: categories, bloc: bloc,),));
        },
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
