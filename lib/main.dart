import 'package:flutter/material.dart';
import 'package:flutter_restaurant/view_model/restaurant_index.dart';
import 'package:sizer/sizer.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Food App",
          home: RestaurantIndex(),
        );
      },
    );
  }
}
