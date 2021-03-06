import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import '../containers/focused_menu.dart';
import '../screens/category_screen.dart';
import '../storage.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> t;
  List<dynamic> categories = Storage.categories;

  ScrollController scrollController = new ScrollController();
  int viewItems = 4;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        viewItems += 4;
        // print(viewItems);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    t = Storage.products.toList();
    t.sort((a, b) {
      if (b['o'] > a['o'])
        return -1;
      else
        return 1;
    });
    return Container(
      color: Storage.APP_COLOR,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Storage.cart == null
            ? Column(
                children: <Widget>[
                  LinearProgressIndicator(),
                  Container(
                    constraints: BoxConstraints(maxWidth: 360),
                    color: Colors.white,
                    child: AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Carousel(
                        showIndicator: false,
                        autoplay: false,
                        defaultImage: Image.asset('assets/logo/logo.jpg'),
                        images: [],
                ),
              ),
            ),
          ],
        )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: AspectRatio(
                              aspectRatio: 4 / 2,
                              child: Carousel(
                                showIndicator: false,
                                autoplay: true,
                                defaultImage:
                                    Image.asset('assets/logo/logo.jpg'),
                                images: List.generate(
                                    Storage.shop_details['sliders'].length,
                                    (index) => CachedNetworkImage(
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                            errorWidget: (context, url, error) =>
                                Center(child: Text('Image')),
                            useOldImageOnUrlChange: true,
                                          imageUrl:
                                              'https://firebasestorage.googleapis.com/v0/b/modern-mart.appspot.com/o/Sliders%2Fimage1?alt=media&token=' +
                                                  Storage.shop_details[
                                                      'sliders'][index]['url'],
                                          fit: BoxFit.cover,
                                        )),
                              ),
                            ),
                          ),
                        ),
                        t.length > 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "New Arrival",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: List<Widget>.generate(
                                            t.length < 5 ? t.length : 5,
                                            (index) {
                                      return ProductCard(
                                        snap: t[index],
                                        hw: true,
                                      );
                                    }).toList()),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  )
                                ],
                              )
                            : Container()
                      ] +
                      List<Widget>.generate(
                          min<int>(viewItems, categories.length), (i) {
                        t = List.from(Storage.products.where((element) {
                          return element['c'] == i;
                        }));
                        if (t.length == 0) {
                          return Container();
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      categories[i],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(createRoute(
                                            CategoryScreen(categories[i],
                                                products: List.from(Storage
                                                    .products
                                                    .where((element) {
                                          return element['c'] == i;
                                        })))));
                                      },
                                      child: Text(
                                        'More',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List<Widget>.generate(
                                          t.length < 5 ? t.length : 5, (index) {
                                        return ProductCard(
                                          snap: t[index],
                                          hw: true,
                                        );
                                      }).toList() +
                                      [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                createRoute(CategoryScreen(
                                                    categories[i], products:
                                                        List.from(Storage
                                                            .products
                                                            .where((element) {
                                              return element['c'] == i;
                                            })))));
                                          },
                                          child: Container(
                                            width: 160,
                                            height: 236,
                                            child: Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'More',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.indigo),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              )
                            ],
                          );
                        }
                      }) +
                      [
                        Text(
                            "${viewItems < categories.length ? "Loading..." : ""}")
                      ],
                ),
              ),
      ),
    );
  }

  Route createRoute(dest) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => dest,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, 1);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/*
import 'package:flutter/material.dart';
import '../containers/category_card.dart';
import '../screens/category_screen.dart';
import '../storage.dart';

class Storage.categoriesScreen extends StatelessWidget {
  List<String> categories = [
//    'All',
    'Atta & Flour',
    'Beverages',
    'Body Sprays',
    'Chocolates',
    'Cleaners',
    'Dals & Pulses',
    'Dairy',
    'Dry Fruits',
    'Edible Oils',
    'Hair Oils',
    'Masala',
    'Patanjali',
    'Personal Hygiene',
    'Pooja Products',
    'Rice & Rice Products',
    'Salt, Sugar & Tea',
    'Snacks and Food',
    'Soaps and Shampoo',
    'Spices',
    'Stationary',
    'Vegetables',
//    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Storage.APP_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            return GridView.count(
              crossAxisCount: 2,
              children: List.generate(Storage.categories.length, (index) {
                return CategoryCard(
                  Storage.categories[index],
                  onTap: () {
                    Navigator.of(context).push(createRoute(CategoryScreen(
                        Storage.categories[index],
                        products: List.from(Storage.products.where((element) {
                      return element['c'] == Storage.categories[index];
                    })))));
                  },
                  index: (index % 2) + 1,
                );
              }).toList(),
            );
          } else {
            return GridView.count(
              crossAxisCount: 4,
              children: List.generate(Storage.categories.length, (index) {
                return CategoryCard(
                  Storage.categories[index],
                  onTap: () {
                    Navigator.of(context).push(createRoute(CategoryScreen(
                        Storage.categories[index],
                        products: List.from(Storage.products.where((element) {
                      return element['c'] == Storage.categories[index];
                    })))));
                  },
                  index: (index % 2) + 1,
                );
              }).toList(),
            );
          }
        }),
      ),
    );
  }

  Route createRoute(dest) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => dest,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, 1);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
*/
