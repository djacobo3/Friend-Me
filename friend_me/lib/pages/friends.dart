import 'package:flutter/rendering.dart';
import 'package:friend_me/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:friend_me/widgets/friends_functions.dart';

class FriendsRoute extends StatefulWidget {
  FriendsRoute({super.key});

  @override
  State<FriendsRoute> createState() => FriendsRouteState();
}

class FriendsRouteState extends State<FriendsRoute> {
  bool offline = true;

  late List<User> Friends = [];
  late List<User> Users = [];
  late List<friendRequest> fReqeusts = [];
  String? uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // appBar: const NavBar(),
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: const NavBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: TabBar(
                    tabs: [
                      Tab(
                        text: 'Friends',
                      ),
                      Tab(
                        text: 'Pending Requests',
                      ),
                      Tab(
                        text: 'Search',
                      ),
                    ],
                  ),
                ),
                Expanded(child:
                TabBarView(
                    children: <Widget>[
                      FutureBuilder<fFutureResults>(
                          future:
                              fetchFriendsandUIDoffline(), //remove offline to use http functions
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              if (snapshot.data?.uid != null &&
                                  snapshot.data?.Response.statusCode == 200) {
                                uid = snapshot.data?.uid;
                                if (offline) {
                                  print("offline!");
                                  Friends = listUsersOffline();
                                } else {
                                  print("notoffline decodinglist");
                                  Friends = listUsers(snapshot.data?.Response);
                                }
                                return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                    ),
                                    itemCount: Friends.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        width: 200.0,
                                        height: 100.0,
                                        child: Card(
                                            margin: EdgeInsets.all(10.0),
                                            child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text('${Friends[index].username}'), 
                                                  SizedBox(height: 10),
                                                  Text('${Friends[index].email}'), 
                                                  SizedBox(height: 10),
                                                  Text('${Friends[index].first_name} ${Friends[index].last_name} '), 
                                                  SizedBox(height: 10),
                                                  ],))),
                                      );
                                    });
                              }
                            }
                            return CircularProgressIndicator();
                          }),
                      Card(
                        child: ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text('Frank Herbert\n'),
                            trailing: ElevatedButton(
                              onPressed: () {},
                              child: Text("Button"),
                            )),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: TextField(
                            decoration: const InputDecoration(
                                hintText: 'Search for User...'),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ],
                  ),),
                
              ],
            ))); // Scaffold
  }
}
