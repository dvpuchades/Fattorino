import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:webapp/screens/starter.dart';
import 'package:webapp/services/brand.dart';
import 'package:webapp/services/geocoding.dart';
import 'package:webapp/services/restaurant.dart';

import '../constants.dart';

class BrandMenu extends StatefulWidget {
  const BrandMenu({Key? key}) : super(key: key);

  @override
  _BrandMenuState createState() => _BrandMenuState();
}

class _BrandMenuState extends State<BrandMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // ignore: prefer_const_literals_to_create_immutables
        children: [const SearchBrandWidget(), const CreateBrandWidget()],
      ),
    ));
  }
}

class SearchBrandWidget extends StatelessWidget {
  const SearchBrandWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        width: 400,
        child: Card(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              padding: const EdgeInsets.all(15),
              child: const Text('Search an existing brand',
                  style: SubtitleTextStyle())),
          Container(
              padding: const EdgeInsets.all(15),
              child: TypeAheadField(
                textFieldConfiguration: const TextFieldConfiguration(
                    autofocus: true,
                    style: TextStyle(color: Colors.green),
                    decoration: InputDecoration(
                        label: Text('Search an existing brand'),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true)),
                suggestionsCallback: (pattern) async {
                  return await getBrandSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                      leading: const Icon(Icons.search),
                      title: Text(suggestion as String));
                },
                onSuggestionSelected: (suggestion) async {
                  String result =
                      await requestBrandAccess(suggestion.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                },
                errorBuilder: (context, error) {
                  return const ListTile(
                      leading: Icon(Icons.error),
                      title: Text('No brand suggested'));
                },
              ))
        ])));
  }
}

class CreateBrandWidget extends StatefulWidget {
  const CreateBrandWidget({Key? key}) : super(key: key);

  @override
  _CreateBrandWidgetState createState() => _CreateBrandWidgetState();
}

class _CreateBrandWidgetState extends State<CreateBrandWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController brandname = TextEditingController();
  TextEditingController restaurant = TextEditingController();
  TextEditingController restaurantAddress = TextEditingController();
  TextEditingController restaurantPostcode = TextEditingController();
  TextEditingController restaurantCity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
            height: 500,
            width: 400,
            child: Card(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(15),
                    child: const Text('Create a new brand',
                        style: SubtitleTextStyle())),
                Container(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      controller: brandname,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.shop),
                        labelText: 'brand name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a brand name';
                        }
                        return null;
                      },
                    )),
                Container(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      controller: restaurant,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.restaurant),
                        labelText: 'restaurant name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a restaurant name';
                        }
                        return null;
                      },
                    )),
                Container(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      controller: restaurantAddress,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.location_searching),
                        labelText: 'restaurant address',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a restaurant address';
                        }
                        return null;
                      },
                    )),
                Container(
                  child: Row(children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              controller: restaurantCity,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.location_city),
                                labelText: 'city',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a restaurant city';
                                }
                                return null;
                              },
                            ))),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              controller: restaurantPostcode,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.location_pin),
                                labelText: 'postcode',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a restaurant postcode';
                                }
                                return null;
                              },
                            ))),
                  ]),
                ),
                Container(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          LatLng? coordinates = await getCoordinates(
                              restaurantAddress.text,
                              restaurantCity.text,
                              restaurantPostcode.text);
                          if (coordinates == null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Address not found'),
                                    content: const Text(
                                        'Could not find the location of the restaurant'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else {
                            createBrand(brandname.text).then((status) => {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(status))),
                                  if (status == 'Brand created successfully')
                                    {
                                      createRestaurant(
                                              restaurant.text,
                                              restaurantAddress.text,
                                              restaurantCity.text,
                                              restaurantPostcode.text,
                                              coordinates)
                                          .then((status) => {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(status))),
                                                if (status ==
                                                    'Restaurant created successfully')
                                                  {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Starter()),
                                                    )
                                                  }
                                              })
                                    }
                                });
                          }
                        }
                      },
                      child: const Text('Create'),
                    )),
              ],
            ))));
  }
}
