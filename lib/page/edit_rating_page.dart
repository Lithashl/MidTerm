import 'package:flutter/material.dart';
import 'package:rate_in_stars/rate_in_stars.dart';
import '../db/db_rating.dart';
import '../model/rating.dart';
import '../widget/rating_form_widget.dart';

class AddEditRatingPage extends StatefulWidget {
  final Rating? rating;

  const AddEditRatingPage({
    Key? key,
    this.rating,
  }) : super(key: key);

  @override
  State<AddEditRatingPage> createState() => _AddEditRatingPageState();
}

class _AddEditRatingPageState extends State<AddEditRatingPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  late int starCount;

  @override
  void initState() {
    super.initState();

    isImportant = widget.rating?.isImportant ?? false;
    number = widget.rating?.number ?? 0;
    title = widget.rating?.title ?? '';
    description = widget.rating?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: RatingFormWidget(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        onChangedImportant: (isImportant) =>
            setState(() => this.isImportant = isImportant),
        onChangedNumber: (number) => setState(() => this.number = number),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey.shade700 ,

        ),

        onPressed: addOrUpdateRating,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateRating() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.rating != null;

      if (isUpdating) {
        await updateRating();
      } else {
        await addRating();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateRating() async {
    final rating = widget.rating!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,

    );

    await RatingDatabase.instance.update(rating);
  }

  Future addRating() async {
    final rating = Rating(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await RatingDatabase.instance.create(rating);
  }
}
