//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/utils/admob_utils.dart';
import 'dart:async';
import 'package:recipes_app/utils/web_utils.dart';
import 'dart:io';

import 'package:recipes_app/view_models/main_page_view_model.dart';
import 'package:recipes_app/services/reciepes_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:recipes_app/views/pages/favorites_page.dart';

import 'package:recipes_app/views/widgets/categories_panel.dart';
import 'package:recipes_app/views/widgets/recent_recipes_panel.dart';

import 'package:recipes_app/configs/config.dart';
import 'package:share/share.dart';

import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {

  MainPageViewModel viewModel;
  TabController tabController;

  RecentRecipesPanel recentRecipesPanel = RecentRecipesPanel();
  CategoriesPanel categoriesPanel = CategoriesPanel();

  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  bool _isSearching;
  String _searchText = '';
  List searchResult = new List();

  static final String GDPR_KEY = "GDPR_KEY";

//  BannerAd _bannerAd;

  final List<Tab> tabs = <Tab>[
    Tab(text: 'CATEGORY'),
    Tab(text: 'RECENT RECIPES'),
  ];

  Future loadData() async {
    await viewModel.setCategories();
    await viewModel.setRecentRecieps();
    await viewModel.setFavorites();
  }

  @override
  void initState() {
    super.initState();
    // init banner ad
//    _bannerAd = AdmobUtils.createBannerAd()..load();

    viewModel = MainPageViewModel(api: RecipesService());
    tabController = TabController(vsync: this, length: tabs.length);
    loadData();


    WidgetsBinding.instance.addPostFrameCallback((_) async => _gdpr());
  }


  Future<void> _gdpr() async {
    // load event from shared prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(GDPR_KEY) == null) {
      return await showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Accept Terms and conditions of use'),
            actions: <Widget>[
              FlatButton(
                child: Text('Accept'),
                onPressed: () {
                  //
                  // set GDPR is accepted in prefs
                  //
                  prefs.setBool(GDPR_KEY, true);
                  // dismiss dialog
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Read Terms'),
                onPressed: () {
                  WebUtils.launchURL(Config.terms_url);
                },
              ),
            ],
          );
        },
      );
    }
  }


  var new_recipes, category, fav, rate, share, terms, about;

  void init_drawer(BuildContext context) {
    new_recipes = ListTile(
      leading: Icon(Icons.local_dining),
      title: Text('New Recipes'),
      onTap: () {
        tabController?.animateTo(0);
        Navigator.pop(context); // close the drawer
      },
    );

    category = ListTile(
      leading: Icon(Icons.apps),
      title: Text('Category'),
      onTap: () {
        tabController.animateTo(1);
        Navigator.pop(context); // close the drawer
      },
    );

    fav = ListTile(
      leading: Icon(Icons.favorite),
      title: Text('Favorite'),
      onTap: () {
        // close the drawer
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavoritesPage(title: 'Favorites'),
            ));
      },
    );

    rate = ListTile(
      leading: Icon(Icons.rate_review),
      title: Text('Rate'),
      onTap: () {
        // open link : https://itunes.apple.com/app/id378458261
        if (Platform.isAndroid) {
          WebUtils.launchURL(
              'https://play.google.com/store/apps/details?id=${Config.androidAppId}');
        } else {
          WebUtils.launchURL('https://itunes.apple.com/app/${Config.iosAppId}');
        }
        // close the drawer
        Navigator.pop(context);
      },
    );

    share = ListTile(
      leading: Icon(Icons.share),
      title: Text('Share'),
      onTap: () {
        String message = '';
        if (Platform.isAndroid) {
          message =
              'I Would like to share this with you. Here You Can Download This Application from PlayStore : https://play.google.com/store/apps/details?id=${Config.androidAppId}';
        } else if (Platform.isIOS) {
          message =
              'I Would like to share this with you. Here You Can Download This Application from AppStore : https://itunes.apple.com/app/${Config.iosAppId}';
        }
        Share.share(message);
        // close the drawer
        Navigator.pop(context);
      },
    );

    about = ListTile(
      leading: Icon(Icons.info),
      title: Text('About'),
      onTap: () {
        WebUtils.launchURL(Config.about_us_url);
        Navigator.pop(context); // close the drawer
      },
    );

    terms = ListTile(
      leading: Icon(Icons.assignment),
      title: Text('Terms'),
      onTap: () {
        WebUtils.launchURL(Config.terms_url);
        Navigator.pop(context); // close the drawer
      },
    );
  }

  _MainPageState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  Widget appBarTitle = new Text(
    Config.appName,
    style: TextStyle(
      fontFamily: 'Distant Galaxy',
    ),
  );

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3.0,
          tabs: tabs,
        ),
        actions: <Widget>[
          new IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  this.icon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _controller,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)),
                    onChanged: searchOperation,
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                  searchOperation('');
                }
              });
            },
          ),
        ]);
  }

  void searchOperation(String searchText) {
    setState(() {
      recentRecipesPanel = RecentRecipesPanel(filter: searchText);
      categoriesPanel = CategoriesPanel(filter: searchText);
    });
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        Config.appName,
        style: TextStyle(
          fontFamily: 'Distant Galaxy',
        ),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  printBundelID () async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('Package Info: ${packageInfo.packageName}');
  }

  @override
  Widget build(BuildContext context) {

    printBundelID();

//    _bannerAd
//      ..load()
//      ..show();

    init_drawer(context);
    return new Scaffold(
      appBar: buildAppBar(context),
      body: ScopedModel<MainPageViewModel>(
        model: viewModel,
        child: TabBarView(
          controller: tabController,
          children: <Widget>[
            categoriesPanel,
            recentRecipesPanel,
          ],
        ),
      ),
      drawer: new Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width - 90,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/images/header.jpg',
                    fit: BoxFit.cover,
                  ),
                  new Center(
                    widthFactor: MediaQuery.of(context).size.width - 90,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 0.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/profile.png',
                            width: 80.0,
                            height: 80.0,
                          ),
                          Text(
                            'Your Recipes',
                            style:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              padding: EdgeInsets.all(0.0),
            ),
            new_recipes,
            category,
            fav,
            rate,
            share,
            terms,
            about,
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
//    _bannerAd?.dispose();
    super.dispose();
  }
}
