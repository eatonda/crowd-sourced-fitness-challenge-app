import 'package:fitness_gurus_challenger/models/challenge.dart';
import 'package:fitness_gurus_challenger/models/search_parameters.dart';
import 'package:fitness_gurus_challenger/services/database_service.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';

class SearchForm extends StatefulWidget {
  final listOfTypes = [
    "Cardio Anaerobic (Speed and Power)",
    "Strength",
    "Flexibility",
    "Cross-Training",
    "Cardio Aerobic(Endurance)"
  ];
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _navigationService = NavigationService();
  final _databaseService = DataBaseService();
  SearchParameters searchParameters = SearchParameters();
  final _formKey3 = GlobalKey<FormState>();
  final int _maxTitle = 26;
  final int _maxTags = 50;
  String error = "";
  Challenge dto = Challenge();
  List<Challenge> results;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    final _spacing = MediaQuery.of(context).size.width * .1;

    return Form(
      key: _formKey3,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                // Store value on valid input when form is submitted.
                searchParameters.title = value;
              },
              validator: (value) {
                // Validate input.
                if (value.length > _maxTitle) {
                  return 'Title cannot be longer that $_maxTitle characters';
                } else {
                  // Valid data return null
                  return null;
                }
              },
            ),

            // Space
            SizedBox(
              height: _spacing,
            ),

            DropdownButtonFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: getDropDownTypeItems(),
              value: dto.type,
              onChanged: (value) {
                setState(() {
                  dto.type = value;
                });
              },
              validator: (value) {
                // Valid data return null
                return null;
              },
              onSaved: (value) => searchParameters.type = value,
            ),

            //
            //Spacing
            SizedBox(
              height: _spacing,
            ),

            // Challenge Tags
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Tags',
                border: OutlineInputBorder(),
              ),
              maxLength: _maxTags,
              // ignore: deprecated_member_use
              maxLengthEnforced: true,
              minLines: 1,
              maxLines: 5,
              onSaved: (value) {
                // Store tags in temp string
                String tags = value;
                dto.getTag(tags);
                print("tags:  ${dto.tags}");
                searchParameters.tags = dto.tags;
              },
              validator: (value) {
                // Validate input.
                if (value.isNotEmpty) {
                  if (value.indexOf('#') == -1) {
                    return "Tags must start with # and be deliminted by space ''";
                  } else if (value.length > _maxTags) {
                    return 'Tags must be between 1 and $_maxTags characters';
                  } else {
                    return null;
                  }
                } else {
                  // Valid data return null
                  return null;
                }
              },
            ),

            //Spacing
            SizedBox(
              height: _spacing,
            ),

            ElevatedButton.icon(
              label: Text('Search'),
              icon: Icon(Icons.search),
              onPressed: () async {
                setState(() {
                  results = null; // clear old search
                });
                // Save Valid Submissions.
                if (_formKey3.currentState.validate()) {
                  _formKey3.currentState.save();
                  results = await _databaseService
                      .getListOfChallenges(searchParameters);

                  if (results.length == 0) {
                    error =
                        'No challenges were found!\nTry Again with different search parameteres.';
                  } else {
                    error = "";
                  }

                  setState(() {});
                }
              },
            ),

            error.length != 0
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
            Text(
              error,
              style: TextStyle(color: Colors.red),
            ),

            results != null
                ? searchResults(context, results)
                : SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
          ],
        ),
      ),
    );
  }

  // Returns a list of DropDownMenuItems for the type field.
  List getDropDownTypeItems() {
    return widget.listOfTypes.map((type) {
      return DropdownMenuItem(
        child: Text(type),
        value: type,
      );
    }).toList();
  }

  Widget listTileFromChallenge(Challenge challenge, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(challenge.coverUrl)),
      title: Text(challenge.title),
      trailing: Text(challenge.type),
      onTap: () =>
          _navigationService.navigateToFitnessTracker(context, challenge),
    );
  }

  Widget searchResults(BuildContext context, List<Challenge> challenges) {
    // print(challenges[0].title);
    return Container(
      child: Flexible(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              return listTileFromChallenge(challenges[index], context);
            }),
        fit: FlexFit.loose,
      ),
    );
  }
}
