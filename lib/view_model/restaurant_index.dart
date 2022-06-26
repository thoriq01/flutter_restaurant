import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_restaurant/models/api/RestaurantApi.dart';
import 'package:flutter_restaurant/models/repository/RestaurantRepository.dart';
import 'package:flutter_restaurant/view/RestaurantCard.dart';
import 'package:flutter_restaurant/view/RestaurantDetail.dart';

// ignore: must_be_immutable
class RestaurantIndex extends StatefulWidget {
  RestaurantIndex({
    Key? key,
  }) : super(key: key);

  @override
  State<RestaurantIndex> createState() => _RestaurantIndexState();
}

class _RestaurantIndexState extends State<RestaurantIndex> {
  var _foodTextController = TextEditingController();
  var _restaurantApi = RestaurantApi();

  List<Restaurants> _listRestaurant = [];
  Future<List<Restaurants>?> _loadRestaurant() async {
    var response = await _restaurantApi.loadRestaurant;
    Map data = jsonDecode(response);
    List dataRestaurant = data["restaurants"];
    _listRestaurant = dataRestaurant.map((e) => Restaurants.fromJson(e)).toList();
    return dataRestaurant.map((e) => Restaurants.fromJson(e)).toList();
  }

  int _selectedRestaurant = -1;
  bool _isSelectedRestaurant = false;
  List<String> _foodName = [];
  var _restaurant = Restaurants();
  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Cari Menu Favoritmu Disini",
              style: TextStyle(color: Colors.deepOrange, fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _foodTextController,
              onChanged: (value) {
                Future.delayed(Duration(milliseconds: 500), () {
                  var c = _listRestaurant.first.name!.toLowerCase().contains(_foodTextController.text);
                });
              },
              decoration: InputDecoration(
                  hintText: "Cari makanan favoritmu disini",
                  fillColor: Colors.grey.shade100,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter Restaurant",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                _isSelectedRestaurant == true
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            _isSelectedRestaurant = false;
                            _selectedRestaurant = -1;
                            _restaurant = new Restaurants();
                          });
                        },
                        child: Text("Reset"),
                      )
                    : Text(""),
              ],
            ),
            SizedBox(height: 15),
            Container(
              height: 40,
              child: Expanded(
                child: FutureBuilder<List<Restaurants>?>(
                  future: _loadRestaurant(),
                  builder: (_, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text("Loading");
                      case ConnectionState.done:
                        return ListView.builder(
                          padding: EdgeInsets.all(5),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) {
                            if (snapshot.data!.length < 0) {
                              return Text("Loading");
                            } else {
                              return Container(
                                height: 30,
                                width: 140,
                                margin: EdgeInsets.only(right: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _restaurant = new Restaurants();
                                      _selectedRestaurant = index;
                                      _isSelectedRestaurant = true;
                                      _restaurant = _listRestaurant[index];
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: _selectedRestaurant == index ? Colors.black : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Center(
                                      child: Text(
                                        snapshot.data![index].name!,
                                        style: TextStyle(color: _selectedRestaurant == index ? Colors.white : Colors.deepOrange, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                    }
                    return Text("data");
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            Builder(builder: (context) {
              if (!_isSelectedRestaurant) {
                return Text(
                  "Popular Restaurant",
                  style: TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.w700),
                );
              } else {
                return Text(
                  _restaurant.name!,
                  style: TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.w700),
                );
              }
            }),
            SizedBox(height: 15),
            Builder(builder: (_) {
              if (_isSelectedRestaurant == true) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Daftar Menu Makanan",
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _restaurant.menus!.foods!.length,
                          itemBuilder: (_, i) {
                            if (_restaurant.menus!.foods != null) {
                              return Container(
                                child: Text(_restaurant.menus!.foods![i].name!),
                              );
                            } else {
                              return Container(
                                child: Text("Loading Data"),
                              );
                            }
                          },
                        ),
                      ),
                      Text(
                        "Daftar Menu Minuman",
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _restaurant.menus!.drinks!.length,
                          itemBuilder: (_, i) {
                            return Container(
                              child: Text(_restaurant.menus!.drinks![i].name!),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Expanded(
                  child: FutureBuilder<List<Restaurants>?>(
                    future: _loadRestaurant(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: Text("Loading Restaurant"),
                          );
                        case ConnectionState.done:
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 4,
                            ),
                            padding: EdgeInsets.all(8),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RestaurantDetail(
                                                restaurants: snapshot.data![i],
                                              )));
                                },
                                child: RestaurantCard(
                                  restaurants: snapshot.data![i],
                                ),
                              );
                            },
                          );
                      }
                      return Text("");
                    },
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
