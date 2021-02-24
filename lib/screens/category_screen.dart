import 'package:flutter/material.dart';

import '../containers/focused_menu.dart';
import '../containers/title_text.dart';
import '../storage.dart';

class CategoryScreen extends StatefulWidget {
  String category;
  List<dynamic> products;

  CategoryScreen(this.category, {@required this.products});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: TitleText(
          widget.category,
          cart: false,
          back: true,
        ),
      ),
      backgroundColor: Storage.APP_COLOR,
      body: Container(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
        child: widget.products.length != 0
            ? LayoutBuilder(
                builder: (context, constraints) {
                  List<dynamic> visproducts = widget.products;
                  if (visproducts.length != 0) {
                    if (constraints.maxWidth <= 600) {
                      return GridView.count(
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 0.72,
                        children: List.generate(visproducts.length, (index) {
                          return ProductCard(
                            hw: false,
                            snap: visproducts[index],
                          );
                        }),
                      );
                    } else {
                      return GridView.count(
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        childAspectRatio: 0.68,
                        children: List.generate(visproducts.length, (index) {
                          return ProductCard(
                            snap: visproducts[index],
                            hw: false,
                          );
                        }),
                      );
                    }
                  } else {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text('No Products'),
                    ));
                  }
                },
              )
            : Center(
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text('No Products'),
              )),
      ),
    );
  }
}
