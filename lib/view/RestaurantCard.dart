import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/repository/RestaurantRepository.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurants restaurants;
  const RestaurantCard({
    Key? key,
    required this.restaurants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              width: MediaQuery.of(context).size.width * 100,
              fit: BoxFit.cover,
              height: 110,
            ),
          ),
          SizedBox(height: 5),
          Text(
            restaurants.name!,
            style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.w700, fontSize: 14),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Icon(Icons.star, color: Colors.greenAccent.shade400, size: 18), SizedBox(width: 5), Text(restaurants.rating!.toString())],
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                restaurants.city!,
                style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 14),
              )
            ],
          ),
        ],
      ),
    );
  }
}
