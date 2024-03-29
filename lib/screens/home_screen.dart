import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/calls_screen.dart';
import 'package:whatsapp/screens/camera_screen.dart';
import 'package:whatsapp/screens/chat_screen.dart';
import 'package:whatsapp/screens/linkedDevices.dart';
import 'package:whatsapp/screens/newBroadcast.dart';
import 'package:whatsapp/screens/newGroup.dart';
import 'package:whatsapp/screens/payments.dart';
import 'package:whatsapp/screens/settings/main_setting_screen.dart';
import 'package:whatsapp/screens/starredMessages.dart';
import 'package:whatsapp/screens/status_screen.dart';

late List<Contact> contacts;

Future<void> getContacts() async {
  final Iterable<Contact> contact = await ContactsService.getContacts();
  // setState(() {
  contacts = contact.toList();
  // });
}

class CustomDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.chevron_left), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty)
      listToShow = contacts
          .where((e) =>
              e.displayName!.contains(query) &&
              e.displayName!.startsWith(query))
          .toList();
    else
      listToShow = contacts;

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var noun = listToShow[i].displayName;
        return ListTile(
          title: Text(
            noun,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onTap: () => close(context, noun),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  static const id = 'chat_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchString = '';

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WhatsApp',
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showSearch(context: context, delegate: CustomDelegate());
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.03,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(color: Colors.grey),
              ),
              child: ListTileTheme(
                child: PopupMenuButton(onSelected: (value) {
                  switch (value) {
                    case 'New group':
                      {
                        Navigator.pushNamed(context, NewGroupList.id);
                        break;
                      }
                    case 'New broadcast':
                      {
                        Navigator.pushNamed(context, NewBroadcast.id);
                        break;
                      }
                    case 'Linked devices':
                      {
                        Navigator.pushNamed(context, LinkedDevices.id);
                        break;
                      }
                    case 'Starred messages':
                      {
                        Navigator.pushNamed(context, StarredMessages.id);
                        break;
                      }
                    case 'Payments':
                      {
                        Navigator.pushNamed(context, Payments.id);
                        break;
                      }
                    case 'Settings':
                      {
                        Navigator.pushNamed(context, MainSettings.id);
                        break;
                      }
                  }
                }, itemBuilder: (context) {
                  return {
                    'New group',
                    'New broadcast',
                    'Linked devices',
                    'Starred messages',
                    'Payments',
                    'Settings'
                  }.map((String choice) {
                    return PopupMenuItem(value: choice, child: Text(choice));
                  }).toList();
                }),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.only(bottom: 10),
            tabs: [
              GestureDetector(
                child: Icon(Icons.photo_camera),
              ),
              GestureDetector(
                child: Text('CHATS'),
              ),
              GestureDetector(
                child: Text('STATUS'),
              ),
              GestureDetector(
                child: Text('CALLS'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CameraScreen(),
            ChatScreen(),
            StatusScreen(),
            CallsScreen()
          ],
        ),
      ),
    );
  }
}
