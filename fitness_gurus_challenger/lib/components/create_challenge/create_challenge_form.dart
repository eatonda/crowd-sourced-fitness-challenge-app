/*
  File Name: create_challenge_form.dart 
  Description: This widget is the form for creating new challenges in the app. 

  Citation(s):
    1. dropdown_formfield 0.1.3
      https://pub.dev/packages/dropdown_formfield
      Assisted with dropdown form functionality

*/

import 'package:fitness_gurus_challenger/components/general/image_thumbnail.dart';
import 'package:fitness_gurus_challenger/models/challenge.dart';
import 'package:fitness_gurus_challenger/models/goal.dart';
import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';
import '../../models/challenge.dart';
import '../../services/database_service.dart';

class CreateChallengeForm extends StatefulWidget {
  final listOfBadgeUrls;

  final listOfTypes = [
    "Cardio Anaerobic (Speed and Power)",
    "Strength",
    "Flexibility",
    "Cross-Training",
    "Cardio Aerobic(Endurance)"
  ];

  final challengeDTO;

  CreateChallengeForm({
    @required this.listOfBadgeUrls,
    @required this.challengeDTO,
  });

  @override
  _CreateChallengeFormState createState() =>
      _CreateChallengeFormState(challengeDTO);
}

class _CreateChallengeFormState extends State<CreateChallengeForm> {
  final _formKey = GlobalKey<FormState>();
  final _databaseService = DataBaseService();
  final _navigationService = NavigationService();
  Challenge challengeDTO;
  _CreateChallengeFormState(this.challengeDTO);

  final int _maxTitle = 26;
  final int _maxDesc = 500;
  final int _maxTags = 50;
  var badgeItems;
  String error;

  @override
  Widget build(BuildContext context) {
    print('At create challenge form');
    //print("${challengeDTO.goals.first.title}");

    final _spacing = MediaQuery.of(context).size.width * .1;
    print(widget.listOfTypes.length);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Challenge Title
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                // Store title in DTO
                challengeDTO.title = value.trimRight();
              },
              validator: (value) {
                // Validate input.
                if (value.isEmpty) {
                  return 'Title cannot be empty!';
                } else if (value.length > _maxTitle) {
                  return 'Title must be between 1 and $_maxTitle characters';
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

            // Challenge Type
            DropdownButtonFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: getDropDownTypeItems(),
              value: challengeDTO.type,
              onChanged: (value) {
                setState(() {
                  challengeDTO.type = value;
                });
              },
              validator: (value) {
                // Validate input.
                if (value == null) {
                  return 'You must select a type';
                }
                // Valid data return null
                return null;
              },
            ),

            //Spacing
            SizedBox(
              height: _spacing,
            ),

            // Challenge Description
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLength: _maxDesc,
              // ignore: deprecated_member_use
              maxLengthEnforced: true,
              minLines: 1,
              maxLines: 25,
              onSaved: (value) {
                // Store description in DTO
                challengeDTO.description = value.trimRight();
              },
              validator: (value) {
                // Validate input.
                if (value.isEmpty) {
                  return 'Description cannot be empty!';
                } else if (value.length > _maxDesc) {
                  return 'Title must be between 1 and $_maxDesc characters';
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
                challengeDTO.getTag(tags);
                print("tags:  ${challengeDTO.tags}");
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

            // Badges
            DropdownButtonFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Badge',
                border: OutlineInputBorder(),
              ),
              items: getDropDownBadgeItems(widget.listOfBadgeUrls),
              value: challengeDTO.badgeUrl,
              onChanged: (value) {
                setState(() {
                  challengeDTO.badgeUrl = value;
                });
              },
              validator: (value) {
                // Validate input.
                if (value == null) {
                  return 'You must select a badge';
                }
                // Valid data return null
                return null;
              },
            ),

            //Spacing
            SizedBox(
              height: _spacing,
            ),

            // Add Goal
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton.icon(
                  onPressed: () => getGoalEntry(context),
                  icon: Icon(Icons.add),
                  label: Text('Add Goal')),
              ElevatedButton(
                onPressed: () => _navigationService
                    .navigateToChallengeGoalListScreen(context, challengeDTO),
                child: Text("# of Goals: ${challengeDTO.goals.length}"),
              ),
            ]),

            // //Spacing
            SizedBox(
              height: _spacing,
            ),

            // Add Challenge Image
            ElevatedButton(
              child: SizedBox(
                  child: challengeDTO.coverUrl == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              Text("Upload Challenge Cover Image"),
                              Icon(Icons.add_a_photo),
                            ])
                      : ImageThumbnail(imageUrl: challengeDTO.coverUrl)),
              onPressed: () => getCoverImage(context),
            ),

            SizedBox(
              height: _spacing,
            ),

            ElevatedButton.icon(
              onPressed: () {
                // Verify Submissions.
                if (_formKey.currentState.validate()) {
                  // Now check goal count to make sure there is at least 1
                  if (validGoalCount(challengeDTO)) {
                    if (challengeDTO.coverUrl == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("You didn't select a cover image"),
                          content: Text(
                              "If you don't select a cover image a random image will be provided."),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // save form
                                _formKey.currentState.save();

                                // get default image url
                                challengeDTO.coverUrl = await _databaseService
                                    .getRandomDefaultImage(challengeDTO.type);

                                // Upload challenge to Database
                                _databaseService
                                    .addChallengeToDatabase(challengeDTO);

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text(
                                        'Congrats!\nYou Successfully Published a Challenge'),
                                    content: Text(
                                        'Thank you for making the world a healthier place!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Navigate out of dialog and create a challenge
                                          _navigationService
                                              .navigateBack(context);
                                          _navigationService
                                              .navigateBack(context);
                                          _navigationService
                                              .navigateBack(context);
                                        },
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  barrierDismissible: false,
                                );
                              },
                              child: Text('Provide a default image for me'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  _navigationService.navigateBack(context),
                              child: Text('I will provide my own image'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Save items in DTO and progress to next page
                      _formKey.currentState.save();

                      // Upload challenge to database
                      _databaseService.addChallengeToDatabase(challengeDTO);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(
                              'Congrats!\nYou Successfully Published a Challenge'),
                          content: Text(
                              'Thank you for making the world a healthier place!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Navigate out of dialog and create a challenge
                                _navigationService.navigateBack(context);
                                _navigationService.navigateBack(context);
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                        barrierDismissible: false,
                      );
                    }
                  } else {
                    // Show alert message to prompt user to add a goal
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            'There must be at least 1 goal associated with challenge'),
                        content: Text('Select Add Goal'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                _navigationService.navigateBack(context),
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      barrierDismissible: false,
                    );
                  }
                }
              },
              icon: Icon(Icons.upload_file),
              label: Text('Publish Challenge'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            // Text(
            //   error,
            //   style: TextStyle(color: Colors.red),
            // ),
          ],
        ),
      ),
    );
  }

  // Returns a list of DropDownMenuItems for the badge field.
  List getDropDownBadgeItems(List badgeUrls) {
    return badgeUrls.map((url) {
      return DropdownMenuItem(
        child: Image.network(url),
        value: url.toString(),
      );
    }).toList();
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

  // Navigates to the Goal Entry Screen and returns form data to this one.
  void getGoalEntry(BuildContext context) async {
    Goal newEntry = await _navigationService.navigateToGoalEntryScreen(context);
    if (newEntry != null) {
      print('goal returned');
      setState(() {
        this.challengeDTO.goals.add(newEntry);
      });
    } else {
      print('No goal returned');
    }
    print(this.challengeDTO.goals[0].title);
  }

  // Get image for challenge cover
  void getCoverImage(BuildContext context) async {
    String url = await _navigationService.navigateToUploadScreen(context);

    if (url.isNotEmpty) {
      print('Image successfully uploaded for challenge');
      setState(() {
        this.challengeDTO.coverUrl = url;
      });
    } else {
      print('No image associated with challenge');
    }
  }

  // Make sure at least one goal is present
  bool validGoalCount(Challenge challenge) {
    if (challenge.goals.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
