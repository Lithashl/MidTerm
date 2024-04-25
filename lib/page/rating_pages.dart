import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rate_in_stars/rate_in_stars.dart';
import '../db/db_rating.dart';
import '../model/rating.dart';
import '../page/edit_rating_page.dart';
import '../page/rating_detail_page.dart';
import '../widget/rating_card_widget.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  late List<Rating> rating;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshRating();
  }

  @override
  void dispose() {
    RatingDatabase.instance.close();

    super.dispose();
  }

  Future refreshRating() async {
    setState(() => isLoading = true);

    rating = await RatingDatabase.instance.readAllRating();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Notes',
        style: TextStyle(fontSize: 24),
      ),
      actions: const [Icon(Icons.search), SizedBox(width: 12)],
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : rating.isEmpty
          ? const Text(
        'No Ratings',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          : buildRating(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.white,
      child: const Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditRatingPage()),
        );

        refreshRating();
      },
    ),
  );
  Widget buildRating() => StaggeredGrid.count(
    // itemCount: rating.length,
    // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
        rating.length,
            (index) {
          final ratings = rating[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RatingDetailPage(ratingId: ratings.id!),
                ));

                refreshRating();
              },
              child: RatingCardWidget(rating: ratings, index: index),
            ),
          );
        },
      )
  );
  Widget buildStars(BuildContext context) {
    return Scaffold(

      body: RatingStars(
        editable: true,
        rating: 3.5,
        color: Colors.amber,
        iconSize: 32,
      ),
    );
  }


}
