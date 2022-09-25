import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/models.dart' show UserScore;
import 'package:quizu/exports/providers.dart' show UserProvider;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //for time formatting
  final format = DateFormat.jm();
  
  //methods
  Widget _getScoresBuilder(List<UserScore> scores) {
    if (scores.isEmpty) {
      return Text(
        "The User has not taken any Quiz!",
        style: Theme.of(context).textTheme.headline6,
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: scores.length,
      itemBuilder: (context, int i) {
        DateTime date = scores[i].date;
        return ListTile(
          leading: Text(
            '${format.format(date)}  ${date.day}/${date.month}/${date.year}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 16,
                ),
          ),
          trailing: Text(
            '${scores[i].score}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Column(
          children: [
            SizedBox(height: 15),
            Text(
              "Profile",
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.black),
            ),
            Text(
              "Name: ${user.user.name}",
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              "Mobile: +966${user.user.mobile.replaceFirst(RegExp(r'0'), '').trim()}",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SizedBox(height: 50),
        Divider(
          thickness: 2,
        ),
        SizedBox(height: 15),
        Column(
          children: [
            Text(
              "Scores",
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                  ),
            ),
            SizedBox(height: 30),
            _getScoresBuilder(user.scores),
          ],
        ),
      ],
    );
  }
}
