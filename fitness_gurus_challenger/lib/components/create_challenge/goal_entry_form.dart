import 'package:fitness_gurus_challenger/components/general/image_thumbnail.dart';
import 'package:flutter/material.dart';
import '../../models/goal.dart';
import '../../services/database_service.dart';
import '../../services/navigation_service.dart';

class GoalEntryForm extends StatefulWidget {
  final listOfTypes = [
    "Cardio Anaerobic (Speed and Power)",
    "Strength",
    "Flexibility",
    "Cross-Training",
    "Cardio Aerobic(Endurance)"
  ];

  GoalEntryForm();
  final navigationService = NavigationService();

  @override
  _GoalEntryFormState createState() => _GoalEntryFormState();
}

class _GoalEntryFormState extends State<GoalEntryForm> {
  final _navigationService = NavigationService();
  final _databaseService = DataBaseService();
  Goal goalDTO = Goal();
  final _formKey = GlobalKey<FormState>();
  final int _maxTitle = 26;
  final int _maxDesc = 500;
  String error = "";

  @override
  Widget build(BuildContext context) {
    final _spacing = MediaQuery.of(context).size.width * .1;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
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
                goalDTO.title = value.trimRight();
              },
              validator: (value) {
                // Validate input.
                if (value.isEmpty) {
                  return 'Title cannot be empty!';
                } else if (value.length > _maxTitle) {
                  return 'Title can be a max of $_maxTitle characters';
                }
                {
                  // Valid data return null
                  return null;
                }
              },
            ),

            // Space
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
              value: goalDTO.type,
              onChanged: (value) {
                setState(() {
                  goalDTO.type = value;
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
                goalDTO.description = value.trimRight();
              },
              validator: (value) {
                // Validate input.
                if (value.isEmpty) {
                  return 'Description cannot be empty!';
                } else if (value.length > _maxDesc) {
                  return 'Description must be between 1 and $_maxDesc characters';
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

            ElevatedButton(
              child: SizedBox(
                  child: goalDTO.coverUrl == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              Text("Upload Goal Cover Image"),
                              Icon(Icons.add_a_photo),
                            ])
                      : ImageThumbnail(imageUrl: goalDTO.coverUrl)),
              onPressed: () => getCoverImage(context),
            ),

            SizedBox(
              height: _spacing,
            ),

            ElevatedButton.icon(
              label: Text('Add Goal'),
              icon: Icon(Icons.save),
              onPressed: () async {
                // Save Valid Submissions.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  if (goalDTO.coverUrl == null) {
                    print('goal form, no coverUrl');
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
                              goalDTO.coverUrl = await _databaseService
                                  .getRandomDefaultImage(goalDTO.type);

                              // Navigate out of dialog and create return Goal to calling widget
                              _navigationService.navigateBack(context);
                              Navigator.pop(context, goalDTO);
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
                    // Return new goal entry to create a challenge form
                    Navigator.pop(context, goalDTO);
                  }
                }
              },
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  // Not DRY (Need refactoring)
  // Returns a list of DropDownMenuItems for the type field.
  List getDropDownTypeItems() {
    return widget.listOfTypes.map((type) {
      return DropdownMenuItem(
        child: Text(type),
        value: type,
      );
    }).toList();
  }

  // Get image for challenge cover
  void getCoverImage(BuildContext context) async {
    String url = await _navigationService.navigateToUploadScreen(context);

    if (url.isNotEmpty) {
      print('Image successfully uploaded for challenge');
      setState(() {
        this.goalDTO.coverUrl = url;
      });
    } else {
      print('No image associated with challenge');
    }
  }
}
