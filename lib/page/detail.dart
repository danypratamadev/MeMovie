import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memovie/widget/appbarcollaps.dart';
import 'package:memovie/widget/recomendationcard.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:memovie/model/mmovie.dart';
import 'package:memovie/provider/mainprovider.dart';

class DetailMovie extends StatelessWidget{

  final MovieModel movie;
  int limitReq = 0;

  DetailMovie({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);

    if(limitReq == 0){
      mainProvider.getDetailsMovie(idMovie: movie.idMovie);
      mainProvider.getRecomendation(idMovie: movie.idMovie);
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
                expandedHeight: mediaApp.size.height * 0.3,
                title: AppBarCollaps(
                  child: Text(
                    '${movie.title}'
                  ),
                ),
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    children: [
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: AspectRatio(
                          aspectRatio: 16/10,
                          child: CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w500/${movie.backdrop}',
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ], 
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Material(
                            color: themeApp.dividerColor,
                            child: CachedNetworkImage(
                              width: 92.0,
                              height: 130.0,
                              imageUrl: 'https://image.tmdb.org/t/p/w500/${movie.image}',
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, progress) => Center(
                                child: SizedBox(
                                  width: 25.0,
                                  height: 25.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                  ),
                                )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: themeApp.textTheme.headline6.copyWith(
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              SizedBox(height: 8.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70.0,
                                    child: Text(
                                      'Genre',
                                      style: themeApp.textTheme.caption,
                                    ),
                                  ),
                                  Text(': ', style: themeApp.textTheme.caption,),
                                  Expanded(
                                    child: Text(
                                      '${value.genreMovie}',
                                      style: themeApp.textTheme.caption,
                                    )
                                  )
                                ],
                              ),
                              SizedBox(height: 7,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70.0,
                                    child: Text(
                                      'Duration',
                                      style: themeApp.textTheme.caption,
                                    ),
                                  ),
                                  Text(': ', style: themeApp.textTheme.caption,),
                                  Expanded(
                                    child: Text(
                                      '${value.durationMovie} Minutes',
                                      style: themeApp.textTheme.caption,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 7,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70.0,
                                    child: Text(
                                      'Release',
                                      style: themeApp.textTheme.caption,
                                    ),
                                  ),
                                  Text(': ', style: themeApp.textTheme.caption,),
                                  Expanded(
                                    child: Text(
                                      '${value.releaseDate}',
                                      style: themeApp.textTheme.caption,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 7,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70.0,
                                    child: Text(
                                      'Age',
                                      style: themeApp.textTheme.caption,
                                    ),
                                  ),
                                  Text(': ', style: themeApp.textTheme.caption,),
                                  Expanded(
                                    child: Text(
                                      movie.adult ? '17+' : '13+',
                                      style: themeApp.textTheme.caption,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Divider(height: 0.5, thickness: 0.3,),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${movie.rate}',
                                        style: themeApp.textTheme.headline5.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.amber
                                        )
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      RatingBar.readOnly(
                                        isHalfAllowed: true,
                                        initialRating: double.parse(movie.rate.toString())/2,
                                        filledIcon: Icons.star_rounded, 
                                        emptyIcon: Icons.star_border_rounded,
                                        halfFilledIcon: Icons.star_half_rounded,
                                        maxRating: 5,
                                        size: 18.0,
                                        filledColor: Colors.amber,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.0),
                                  Text(
                                    '${movie.voteCount} Vote',
                                    style: themeApp.textTheme.overline,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(width: 0.5, thickness: 0.5,),
                        Expanded(
                          flex: 1,
                          child: CupertinoButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  movie.favorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                  color: Colors.pink,
                                ),
                                SizedBox(width: 5.0,),
                                Text(
                                  movie.favorite ? 'Added to Favorite' : 'Add Favorite',
                                  style: themeApp.textTheme.button.copyWith(
                                    color: Colors.pink,
                                  ),
                                )
                              ],
                            ), 
                            onPressed: () async {
                              if(movie.favorite){
                                bool result = await mainProvider.removeFavorite(movie: movie);
                                if(result){
                                  Fluttertoast.showToast(
                                    msg: 'Removed from Favorite Movies',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                              } else {
                                bool result = await mainProvider.saveFavorite(movie: movie);
                                if(result){
                                  Fluttertoast.showToast(
                                    msg: 'Added to Favorite Movies',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                }
                              }
                            }
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(height: 0.5, thickness: 0.3,),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0,),
                    child: Text(
                      'Overview:',
                      style: themeApp.textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0,),
                    child: Text(
                      movie.overview,
                      style: themeApp.textTheme.caption.copyWith(
                        color: themeApp.textTheme.bodyText1.color,
                        height: 1.6,
                        letterSpacing: 0.3
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 42.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0,),
                    child: Text(
                      'Recomendation:',
                      style: themeApp.textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: value.listRecomenMovies.map((recomen) {
                        i++;
                        return RecomendationCard(movie: recomen, index: i);
                      }).toList()
                    ),
                  ),
                  SizedBox(height: mediaApp.size.height * 0.1,),
                ],
              ),
            ),
          );
        }
      ),
    );
    
  }

}