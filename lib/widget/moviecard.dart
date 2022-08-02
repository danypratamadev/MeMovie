import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memovie/model/mmovie.dart';
import 'package:memovie/page/detail.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

class MovieCard extends StatelessWidget {

  final MovieModel movie;

  const MovieCard({Key key, @required this.movie}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    
    var mainprovider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailMovie(movie: movie,),));
        },
        child: Material(
          color: themeApp.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Material(
                    color: themeApp.dividerColor,
                    child: CachedNetworkImage(
                      width: 72.0,
                      height: 110.0,
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
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: themeApp.textTheme.subtitle1.copyWith(
                                    fontWeight: FontWeight.bold
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${movie.rate}',
                                      style: themeApp.textTheme.caption.copyWith(
                                        color: themeApp.textTheme.bodyText1.color,
                                        fontWeight: FontWeight.w600
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
                                      size: 14.0,
                                      filledColor: Colors.amber,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){

                            },
                            child: Icon(
                              movie.favorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: Colors.pink,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        movie.overview,
                        style: themeApp.textTheme.caption.copyWith(
                          height: 1.4,
                          color: themeApp.textTheme.bodyText1.color,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  
}