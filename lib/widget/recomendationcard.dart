import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memovie/model/mmovie.dart';
import 'package:memovie/page/detail.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:provider/provider.dart';

class RecomendationCard extends StatelessWidget {

  final MovieModel movie;
  final int index;

  const RecomendationCard({Key key, @required this.movie, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);
    
    return Consumer<MainProvider>(
      builder: (context, value, child) => Padding(
        padding: EdgeInsets.only(left: index == 0 ? 24.0 : 20.0, right: index == value.listRecomenMovies.length - 1 ? 24.0 : 0.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Material(
                color: themeApp.dividerColor,
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DetailMovie(movie: movie,),));
                  },
                  child: CachedNetworkImage(
                    width: 112.0,
                    height: 150.0,
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
            ),
            SizedBox(height: 8.0,),
            SizedBox(
              width: 112.0,
              child: Text(
                movie.title,
                style: themeApp.textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
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