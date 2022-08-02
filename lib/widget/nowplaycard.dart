import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memovie/model/mmovie.dart';
import 'package:memovie/page/detail.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:provider/provider.dart';

class NowPlayCard extends StatelessWidget {

  final MovieModel movie;
  final int index;

  const NowPlayCard({Key key, @required this.movie, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);
    
    return Consumer<MainProvider>(
      builder: (context, value, child) => Padding(
        padding: EdgeInsets.only(left: index == 0 ? 24.0 : 20.0, right: index == value.listNowplayingMovies.length - 1 ? 24.0 : 0.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Material(
                color: themeApp.dividerColor,
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailMovie(movie: movie,),));
                  },
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        width: 172.0,
                        height: 260.0,
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
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54
                          ),
                          child: Center(
                            child: Text(
                              '${index+1}',
                              style: themeApp.textTheme.subtitle1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade50
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0,),
            SizedBox(
              width: 172.0,
              child: Text(
                movie.title,
                style: themeApp.textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

}