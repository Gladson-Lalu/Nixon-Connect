import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import '../../../../../Services/location_service.dart';

import '../../../../../Cubit/auth/auth_cubit.dart';
import '../../../../../Models/user_model.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel? _user =
        BlocProvider.of<AuthCubit>(context).user;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: const Text(
              "User Information",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4),
                            leading: const Icon(
                                Icons.my_location),
                            title: const Text("Location"),
                            subtitle: FutureBuilder(
                              future: () async {
                                final LocationData?
                                    _location =
                                    LocationService.instance
                                        .locationData;
                                List<
                                        Placemark>
                                    _placeMarks =
                                    await placemarkFromCoordinates(
                                        _location!
                                            .latitude!,
                                        _location
                                            .longitude!);
                                return _placeMarks[0];
                              }()
                                  .then((value) =>
                                      value.locality),
                              builder: (BuildContext
                                      context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                      snapshot.data);
                                } else {
                                  return const Text(
                                      "Loading...");
                                }
                              },
                            ),
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.email),
                            title: const Text("Email"),
                            subtitle: Text(
                                _user!.email.toString()),
                          ),
                          const ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Phone"),
                            subtitle: Text("99-99876-56"),
                          ),
                          const ListTile(
                            leading: Icon(Icons.person),
                            title: Text("About Me"),
                            subtitle: Text(
                                "This is a about me link and you can khow about me in this section."),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
