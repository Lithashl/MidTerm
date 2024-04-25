import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rate_in_stars/rate_in_stars.dart';
import '../db/db_rating.dart';
import '../model/rating.dart';
import '../page/edit_rating_page.dart';

class RatingDetailPage extends StatefulWidget {
  final int ratingId;

  const RatingDetailPage({
    Key? key,
    required this.ratingId,
  }) : super(key: key);

  @override
  State<RatingDetailPage> createState() => _RatingDetailPageState();
}

class _RatingDetailPageState extends State<RatingDetailPage> {
  late Rating rating;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshRating();
  }

  Future refreshRating() async {
    setState(() => isLoading = true);

    rating = await RatingDatabase.instance.readRating(widget.ratingId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],

    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            rating.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat.yMMMd().format(rating.createdTime),
            style: const TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 8),
          Text(
            rating.description,
            style:
            const TextStyle(color: Colors.white70, fontSize: 18),
          )
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditRatingPage(rating: rating),
        ));

        refreshRating();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete),
    onPressed: () async {
      await RatingDatabase.instance.delete(widget.ratingId);

      Navigator.of(context).pop();
    },
  );
}
