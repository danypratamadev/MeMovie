import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memovie/page/account.dart';
import 'package:memovie/page/allmovie.dart';
import 'package:memovie/page/myfavorite.dart';
import 'package:memovie/widget/appbarcollaps.dart';
import 'package:memovie/widget/nowplaycard.dart';
import 'package:memovie/widget/recomendationcard.dart';
import 'package:memovie/widget/moviecard.dart';
import 'package:provider/provider.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:memovie/start/login.dart';

class HomePage extends StatelessWidget {

  int limitReq = 0;
  
  @override
  Widget build(BuildContext context) {

    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);

    if(limitReq == 0){
      Timer(
        Duration(milliseconds: 300,), () async {
          await mainProvider.getNowPlayMovie();
          await mainProvider.getUpcomingMovie();
        }
      );
      limitReq++;
    }

    return Scaffold(
      body: Consumer<MainProvider>(
        builder: (context, value, child) {
          int i = -1;
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              SliverAppBar(
                pinned: true,
                primary: true,
                forceElevated: innerBoxIsScrolled,
                expandedHeight: mediaApp.size.height * 0.18,
                title: AppBarCollaps(
                  child: Text(
                    'MeMovie'
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    children: [
                      Positioned(
                        bottom: 24.0,
                        left: 24.0,
                        right: 24.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, ${value.name.split(' ').first}',
                                    style: themeApp.textTheme.headline4.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text(
                                    'Find all movies on MeMovie',
                                    style: themeApp.textTheme.bodyText2.copyWith(
                                      color: Colors.white60,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 16.0),
                            ClipOval(
                              child: Material(
                                color: themeApp.backgroundColor,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(),));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 32.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ], 
            body: RefreshIndicator(
              onRefresh: () => mainProvider.onRefresh(context: context),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 16.0),
                      child: Text(
                        'Now Playing Movies',
                        style: themeApp.textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if(value.listNowplayingMovies.length > 0)
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: value.listNowplayingMovies.map((recomen) {
                          i++;
                          return NowPlayCard(movie: recomen, index: i);
                        }).toList()
                      ),
                    )
                    else
                    SizedBox(
                      height: 260.0,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.8,
                              ),
                            ),
                            SizedBox(height: 16.0,),
                            Text(
                              'LOADING',
                            )
                          ],
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 32.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Material(
                          color: themeApp.backgroundColor,
                          child: ListTile(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyFavoritePage(),));
                            },
                            title: Row(
                              children: [
                                Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.pink.shade600,
                                ),
                                SizedBox(width: 16.0,),
                                Text(
                                  'My Favorite Movie',
                                  style: themeApp.textTheme.subtitle1.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: themeApp.disabledColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upcoming Movies',
                            style: themeApp.textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                            child: Text(
                              'See All Movie',
                              style: themeApp.textTheme.button.copyWith(
                                color: themeApp.buttonColor,
                              ),
                            ), 
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllMoviesPage(),));
                            }
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0),
                    if(value.listUpcomingMovies.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Column(
                        children: [
                          for(int i = 0; i < 5; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom : 16.0),
                            child: MovieCard(movie: value.listUpcomingMovies[i]),
                          )
                        ],
                      ),
                    ) 
                    else 
                    SizedBox(
                      height: mediaApp.size.height * 0.2,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.8,
                              ),
                            ),
                            SizedBox(height: 16.0,),
                            Text(
                              'LOADING',
                            )
                          ],
                        )
                      ),
                    ),
                    SizedBox(height: mediaApp.size.height * 0.1),
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }

}