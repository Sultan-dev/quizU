import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/components.dart' show LoadingIndicator;
import 'package:quizu/exports/models.dart' show PlayerScore;
import 'package:quizu/exports/services.dart' show NetworkService;

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  //futures
  late final Future<List<PlayerScore>> _fetchPlayerScore;

  //methods
  @override
  void initState() {
    super.initState();
    _fetchPlayerScore = _getPlayerScore();
  }

  Future<List<PlayerScore>> _getPlayerScore() async {
    final network = Provider.of<NetworkService>(context, listen: false);
    return await network.getTop10Scores();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "LeaderBoard",
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.black),
            ),
          ),
          SizedBox(height: 20),
          FutureBuilder<List<PlayerScore>>(
            future: _fetchPlayerScore,
            builder: (BuildContext context,
                AsyncSnapshot<List<PlayerScore>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                List<PlayerScore> playerScore = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: playerScore.length,
                  itemBuilder: (context, int i) {
                    return ListTile(
                      leading: Text(
                        '${playerScore[i].name}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      trailing: Text(
                        '${playerScore[i].score}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingIndicator(isLoading: true);
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: Text(
                    "No Data Available!",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    "Something Went Wrong!",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
