import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {

  final locationWeather;
  final icon;

  LocationScreen({this.locationWeather,this.icon});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weatherModel = WeatherModel();
  int temperature;
  String cityName;
  Image img;
  String msg;

  @override
  void initState() {
    super.initState();
    updateData(widget.locationWeather,widget.icon);
  }

  void updateData(dynamic weatherData,Image icon){
    String temp = weatherData['observations']['location'][0]['observation'][0]['temperature'];
    temperature = double.parse(temp).toInt();
    cityName = weatherData['observations']['location'][0]['observation'][0]['city'];
    msg = weatherModel.getMessage(temperature);
    img = icon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherdata = await GetWeatherData().getWeather();
                      Image _image = Image.network(weatherdata['observations']['location'][0]['observation'][0]['iconLink']+'?apiKey=$apiKey',cacheWidth: 100,cacheHeight: 100,);
                      _image.image.resolve(ImageConfiguration()).addListener(
                        ImageStreamListener(
                              (info, call) {
                                setState(() {
                                  updateData(weatherdata,_image);
                                });
                          },
                        ),
                      );
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(context,MaterialPageRoute(builder: (context){
                      return CityScreen();
                      }
                      ),
                      );
                      if(typedName!=null){
                        var weatherdata = await GetWeatherData().getCityWeather(typedName.toString());
                        Image _image = Image.network(weatherdata['observations']['location'][0]['observation'][0]['iconLink']+'?apiKey=$apiKey',cacheWidth: 100,cacheHeight: 100,);
                        _image.image.resolve(ImageConfiguration()).addListener(
                          ImageStreamListener(
                                (info, call) {
                              setState(() {
                                updateData(weatherdata,_image);
                              });
                            },
                          ),
                        );
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                  img,
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  msg+' in '+cityName,
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

