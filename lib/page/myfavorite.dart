import 'package:flutter/material.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:memovie/widget/appbarcollaps.dart';
import 'package:memovie/widget/moviecard.dart';
import 'package:provider/provider.dart';

class MyFavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);

    return Scaffold(
      body: Consumer<MainProvider>(
        builder: (context, value, child) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverAppBar(
              pinned: true,
              primary: true,
              forceElevated: innerBoxIsScrolled,
              expandedHeight: mediaApp.size.height * 0.18,
              title: AppBarCollaps(
                child: Text(
                  'My Favorite Movies'
                ),
              ),
              backgroundColor: Colors.pink.shade600,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  children: [
                    Positioned(
                      bottom: 24.0,
                      left: 24.0,
                      child: Text(
                        'My Favorite Movies',
                        style: themeApp.textTheme.headline4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),
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
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(value.listFavoriteMovies.length > 0)
                    Column(
                      children: value.listFavoriteMovies.map((movie) => Padding(
                        padding: const EdgeInsets.only(bottom : 16.0),
                        child: MovieCard(movie: movie),
                      )).toList(),
                    ) 
                    else 
                    SizedBox(
                      height: mediaApp.size.height * 0.6,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.movie_rounded,
                              size: 72.0,
                              color: themeApp.disabledColor
                            ),
                            SizedBox(height: 16.0,),
                            Text(
                              'Favorite movie not available',
                              style: themeApp.textTheme.bodyText2.copyWith(
                                color: themeApp.disabledColor
                              ),
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
          ),
        ),
      )
    );
    
  }

}