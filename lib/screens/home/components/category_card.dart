import 'package:app/app_properties.dart';
import 'package:app/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final HiliaCategory category;

  CategoryCard({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 80,
                width: 90,
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        colors: [mediumYellow, yellow],
                        center: Alignment(0, 0),
                        radius: 0.8,
                        focal: Alignment(0, 0),
                        focalRadius: 0.1)),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: AutoSizeText(
                    category.name,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 80,
                width: 80,
                child: category.imageWidget(fit: BoxFit.cover),
              )
            ],
          ),
        ),
      ),
    );
  }
}
