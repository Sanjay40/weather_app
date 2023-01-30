import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Link.dart';

void main() {
  runApp(MaterialApp(
   routes : {
     '/' : (context) => const Weather(),
     'link' : (context) => const Link(),
   }
  ));
}

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final searchText = TextEditingController();
  String srcText = '';
  dynamic data;
  var decodeData;
  double temp = 0;
  int vis = 0;
  int clo = 0;
  int pre = 0;
  double ws = 0.0;
  double mt = 0.0;
  double mit = 0.0;
  double lon = 0.0;
  double lan = 0.0;
  int hum = 0;
  late InAppWebViewController inAppWebViewController;
  
  @override
  void initState() {
    super.initState();
    getDataApiResponse();
    // Uri? url = await inAppWebViewController.getUrl();
    // inAppWebViewController.loadUrl(urlRequest: URLRequest(url: url),);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            SizedBox(
              height: h,
              width: w,
              child: const Image(
                image: AssetImage(
                    'images/eberhard-grossgasteiger-ZTyH1sAOThU-unsplash.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: h,
              width: w,
              color: Colors.black54,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text("Weather App",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                        ),
                        const SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextFormField(
                            controller: searchText,
                            onFieldSubmitted: (val) {

                               setState(() {
                                 srcText = val;
                                 getDataApiResponse();
                               });
                                //setState(() {});
                                //print("krupiya $srcText");
                              //});
                            },
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  CupertinoIcons.search,
                                  color: Colors.white,
                                ),
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      searchText.clear();
                                    });
                                  },
                                  child: const Icon(
                                    CupertinoIcons.clear_circled,
                                    color: Colors.white,
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 1.8,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 1.8,
                                    ))),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Center(
                          child: Text(
                            srcText,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                letterSpacing: 1.2,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${temp.toInt()}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 140,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 75),
                                child: Text("°C",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 180,
                        ),
                        GestureDetector(
                          onTap: ()  {
                            setState(() {
                             if(srcText.isNotEmpty)
                             {
                                 Navigator.pushNamed(context, 'link',arguments: 'https://www.accuweather.com/en/in/$srcText');
                                 // InAppWebView(
                                 //        initialUrlRequest: URLRequest(
                                 //          url: Uri.parse("https://www.google.com"),
                                 //        ),
                                 //   onWebViewCreated: (InAppWebViewController val)
                                 //   {
                                 //     setState(() {
                                 //       inAppWebViewController = val;
                                 //     });
                                 //   },
                                 //      );
                                 // inAppWebViewController.loadUrl(
                                 //     urlRequest: URLRequest(
                                 //         url: Uri.parse("https://www.google.com"),),);
                                 // InAppWebView(
                                 //   initialUrlRequest: URLRequest(
                                 //     url: Uri.parse("https://www.google.com"),
                                 //   ),
                                 // );
                               }
                             else
                               {
                                 print("Error");
                               }
                            });
                              // inAppWebViewController.loadUrl(
                              //     urlRequest: URLRequest(
                              //         url: Uri.parse("https://www.google.co.in/"),),);
                          },
                          child: Container(
                            height: h/12,
                            width: w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            alignment: Alignment.center,
                            child: Text("Full Air Quality Forecast",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontSize: 18,
                            ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: h/2.5,
                          width: w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 30,),
                              Expanded(
                                flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 30,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Visiblity",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("$vis",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Pressure",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("${pre}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Max Temp",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("${mt.toInt()}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Lon",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("${lon.toInt()}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Humbidity",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("$hum",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                              const SizedBox(width: 30,),
                              Expanded(
                                flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 30,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Cloude",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("$clo",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Wind Speed",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("${ws.toInt()}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Min Temp",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("${mit.toInt()}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Lan",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("${lan.toInt()}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDataApiResponse() async {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$srcText&appid=be558c4a9c62cdd04267ab50aafa3784");
    var response = await http.get(url);
    try {
      if (response.statusCode == 200)
      {
        print("hello aapde");
        //Data = response.body;
        //decodeData = JsonDecode(Data);
        data = jsonDecode(response.body);
        //print(data['main']['temp']);
       setState(() {
         temp  = data['main']['temp'] - 275;
          vis = data['visibility'];
         print("hello ${data['visibility']}");
          pre = data['main']['pressure'];
          mt = data['main']['temp_max'];
          lon = data['coord']['lon'];
          hum = data['main']['humidity'];
          clo = data['clouds']['all'];
          ws = data['wind']['speed'];
          mit = data['main']['temp_min'];
          lan = data['coord']['lat'];
       });

        setState(() {});
        // Data = json.decode(response.body);
        // print(Data);
        //data = jsonDecode(response.body);
        //print(data);
        // if (data.isNotEmpty) {
        //   usingData.addAll([data]);
        //   print(usingData);
        // }

        // usingData.addAll(
        //     [
        //   {
        //     'coord': jsonDecode(response.body)['coord'],
        //     'weather': jsonDecode(response.body)['weather'],
        //     'main': jsonDecode(response.body)['main'],
        //     'visibility': jsonDecode(response.body)['visibility'],
        //     'wind': jsonDecode(response.body)['wind'],
        //     'clouds': jsonDecode(response.body)['clouds'],
        //     'dt': jsonDecode(response.body)['dt'],
        //     'sys': jsonDecode(response.body)['sys'],
        //   }
        //    ]
        // );
      }
    } catch(e)
    {
      print(e.toString());
    }
  }
}
