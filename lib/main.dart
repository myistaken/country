import 'dart:convert';
import 'package:countries/models/country.dart';
import 'package:countries/provider/country_provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'models/country.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CountryProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List data;

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/woeid.json');
    setState(() => data = json.decode(jsonText));
    return 'success';
  }

  @override
  void initState() {
    loadJsonData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _counts = context.watch<CountryProvider>().counts;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _counts == null ? 0 : _counts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      onTap: () {
                        print(data[index]["woeid"].toString());
                      },
                      trailing:
                          data[index]["countryCode"].toString().toLowerCase() !=
                                  "null"
                              ? SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: SvgPicture.asset(
                                    'assets/countries/${_counts[index].code.toString().toLowerCase()}.svg',
                                  ),
                                )
                              : null,
                      title: Text(_counts[index].countryCode));
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Select(
                              data: data,
                            ))),

                /*
                showCountryPicker(
                    exclude: ["BE"],
                    context: context,
                    favorite: ["TR"],
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      // ignore: avoid_print
                      print('Select country: ${country.countryCode}');
                      data.forEach((element) {
                        if (element["name"] == country.name) {
                          print(element["name"]);
                          context.read<CountryProvider>().addToList(Countries(
                              countryCode: element["name"],
                              woeid: element["woeid"]));
                        }
                      });
                    },
                    countryListTheme: CountryListThemeData(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ))*/
              },
              child: const Text('Show country picker'),
            ),
          ],
        ),
      ),
    );
  }
}

class Select extends StatelessWidget {
  List data;
  Select({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _counts = context.watch<CountryProvider>().counts;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Region"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  trailing:
                      data[index]["countryCode"].toString().toLowerCase() !=
                              "null"
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                'assets/countries/${data[index]["countryCode"].toString().toLowerCase()}.svg',
                                allowDrawingOutsideViewBox: true,
                              ),
                            )
                          : null,
                  title: Text(
                    data[index]["name"],
                  ),
                  onTap: () {
                    context.read<CountryProvider>().addToList(Countries(
                        countryCode: data[index]["name"],
                        code: data[index]["countryCode"],
                        woeid: data[index]["woeid"]));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
