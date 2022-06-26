import 'package:flutter/services.dart';
import 'package:flutter_restaurant/models/repository/RestaurantRepository.dart';

class RestaurantApi {
  Future get loadRestaurant => _loadRestaurant();
  Future _loadRestaurant() async {
    var response = await rootBundle.loadString('assets/restaurant.json');
    return response;
  }
}
