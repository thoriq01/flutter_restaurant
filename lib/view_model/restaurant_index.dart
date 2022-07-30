import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_restaurant/models/api/RestaurantApi.dart';
import 'package:flutter_restaurant/models/repository/RestaurantRepository.dart';
import 'package:flutter_restaurant/view/RestaurantCard.dart';
import 'package:flutter_restaurant/view/RestaurantDetail.dart';
import 'package:sizer/sizer.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Cari Menu Favoritmu Disini",
                style: TextStyle(color: Colors.deepOrange, fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _foodTextController,
                onChanged: (value) {
                  Future.delayed(Duration(milliseconds: 500), () {});
                },
                decoration: InputDecoration(
                    hintText: "Cari makanan favoritmu disini",
                    fillColor: Colors.grey.shade100,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter Restaurant",
                    style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w700),
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
              SizedBox(height: 10),
              Container(
                height: 40,
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
                                width: 25.w,
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
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                        color: _selectedRestaurant == index ? Colors.black : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20.sp)),
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
              FutureBuilder<List<Restaurants>?>(
                future: _loadRestaurant(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: Text("Loading Restaurant"),
                      );
                    case ConnectionState.done:
                      if (_isSelectedRestaurant) {
                        return Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  _restaurant.name!,
                                  style: TextStyle(color: Colors.deepOrange, fontSize: 18.sp, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Daftar Menu Makanan",
                                  style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w700),
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
                          ),
                        );
                      }

                      return Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.9,
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
                        ),
                      );
                  }
                  return Text("");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
