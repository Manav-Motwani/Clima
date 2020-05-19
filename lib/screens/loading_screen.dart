import 'package:flutter/material.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clima/services/weather.dart';

String status = 'Getting Location...';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  void getLocationData() async {
    var weatherdata = await GetWeatherData().getWeather();
    setState(() {
      status = 'Finishing Up...';
    });
    Image _image = Image.network(weatherdata['observations']['location'][0]['observation'][0]['iconLink']+'?apiKey=$apiKey',cacheWidth: 100,cacheHeight: 100,);
    _image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
            (info, call) {

              Navigator.push(context, MaterialPageRoute(builder : (context){
              return LocationScreen(locationWeather: weatherdata,icon: _image,);
                }));

        },
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    getLocationData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('$status\n\n',
          style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold
          ),
          ),
          SpinKitDoubleBounce(
            color: Colors.white,
            size: 100.0,
          ),
        ],
      ),
    );
  }
}
