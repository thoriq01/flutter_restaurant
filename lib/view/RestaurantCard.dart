import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/repository/RestaurantRepository.dart';
import 'package:sizer/sizer.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurants restaurants;
  const RestaurantCard({
    Key? key,
    required this.restaurants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 2,
            offset: Offset(1, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: NetworkImage(restaurants.pictureId!),
              width: 40.w,
              fit: BoxFit.cover,
              height: 16.h,
            ),
          ),
          SizedBox(height: 5),
          Text(
            restaurants.name!,
            style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.w700, fontSize: 10.sp),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.star, color: Colors.greenAccent.shade400, size: 12.sp),
                  Text(
                    restaurants.rating!.toString(),
                    style: TextStyle(fontSize: 10.sp),
                  )
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                restaurants.city!,
                style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 10.sp),
              )
            ],
          ),
        ],
      ),
    );
  }
}
