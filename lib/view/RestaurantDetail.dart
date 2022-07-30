import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/repository/RestaurantRepository.dart';
import 'package:sizer/sizer.dart';

class RestaurantDetail extends StatefulWidget {
  final Restaurants restaurants;
  const RestaurantDetail({Key? key, required this.restaurants}) : super(key: key);

  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  int _maxLine = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(widget.restaurants.pictureId!),
                  width: 100.w,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurants.name!,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14.sp),
                  ),
                  Text(
                    widget.restaurants.city!,
                    style: TextStyle(color: Colors.grey[900], fontSize: 12.sp),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Icon(Icons.star, color: Colors.deepOrange, size: 6.w), SizedBox(width: 5), Text(widget.restaurants.rating!.toString())],
              ),
              SizedBox(height: 15),
              Text(
                "Sejarah",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
              ),
              SizedBox(height: 5),
              Expanded(
                flex: _maxLine == 2 ? 0 : 1,
                child: Text(
                  widget.restaurants.description!,
                  maxLines: _maxLine,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _maxLine < 3 ? _maxLine = 20 : _maxLine = 2;
                  });
                },
                child: Text(
                  _maxLine > 3 ? "Tampilkan lebih sedikit.." : "Selengkapnya..",
                  style: TextStyle(color: Colors.lightBlue),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Daftar Makanan",
                maxLines: _maxLine,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.restaurants.menus!.foods!.length,
                    itemBuilder: (_, index) {
                      return Text(index.toString() + ". ${widget.restaurants.menus!.foods![index].name}");
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
