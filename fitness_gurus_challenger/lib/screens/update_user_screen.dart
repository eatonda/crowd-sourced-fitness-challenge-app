import 'package:flutter/material.dart';
import '../components/general/image_thumbnail.dart';
import '../components/general/main_app_bar_.dart';
import '../components/general/my_title.dart';
import '../models/app_user.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class UpdateUserScreen extends StatelessWidget {
  static const routeName = "update_user";

  @override
  Widget build(BuildContext context) {
    AppUser appUser = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: MainAppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            MyTitle(title: "Update Your Profile Info"),
            UserInfoForm(
              appUser: appUser,
            ),
          ]),
        ));
  }
}

class UserInfoForm extends StatefulWidget {
  final appUser;
  UserInfoForm({this.appUser});

  @override
  _UserInfoFormState createState() => _UserInfoFormState(appUser: appUser);
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _navigationService = NavigationService();
  final _databaseService = DataBaseService();
  AppUser appUser; // Current info to check if things have changed
  AppUser dto; //Used to store new input and upload to database
  final _formKey = GlobalKey<FormState>();
  final _maxName = 26;
  final _maxBio = 500;
  String error = "";

  _UserInfoFormState({this.appUser});

  @override
  void initState() {
    super.initState();
    dto = appUser.clone();
  }

  @override
  Widget build(BuildContext context) {
    final _spacing = MediaQuery.of(context).size.width * .1;
    print('dto');
    print(appUser.userFormInfoEquivalent(dto));

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // First Name
            TextFormField(
              autofocus: true,
              initialValue: appUser.firstName,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                // Store value on valid input when form is submitted.
                dto.firstName = value.trimRight();
              },
              validator: (value) {
                // Validate input.
                if (value.isEmpty) {
                  return 'First Name Cannot Be Empty!';
                } else if (value.length > _maxName) {
                  return 'First can be a max of $_maxName characters';
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

            // Last Name
            TextFormField(
              autofocus: true,
              initialValue: appUser.lastName,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                // Store value on valid input when form is submitted.
                dto.lastName = value.trimRight();
              },
              validator: (value) {
                // Validate input.
                if (value.isEmpty) {
                  return 'Last Name Cannot Be Empty!';
                } else if (value.length > _maxName) {
                  return 'Last can be a max of $_maxName characters';
                }
                {
                  // Valid data return null
                  return null;
                }
              },
            ),

            //Spacing
            SizedBox(
              height: _spacing,
            ),

            // Bio
            TextFormField(
              autofocus: true,
              initialValue: appUser.bio,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLength: _maxBio,
              // ignore: deprecated_member_use
              maxLengthEnforced: true,
              minLines: 1,
              maxLines: 25,
              onSaved: (value) =>
                  // Store bio in DTO
                  dto.bio = value.trimRight(),

              validator: (value) {
                // Validate input.
                if (value.isEmpty) {
                  return 'Bio cannot be empty!';
                } else if (value.length > _maxBio) {
                  return 'Bio must be between 1 and $_maxBio characters';
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
                  child: dto.profileImageUrl == appUser.profileImageUrl
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              Text("Change Profile Photo"),
                              Icon(Icons.add_a_photo),
                            ])
                      : ImageThumbnail(imageUrl: dto.profileImageUrl)),
              onPressed: () => setState(() => getProfileImage(context)),
            ),

            SizedBox(
              height: _spacing,
            ),

            ElevatedButton.icon(
              label: Text('Submit'),
              icon: Icon(Icons.save),
              onPressed: () async {
                // Save Valid Submissions.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  // Save to database, database eliminates duplication writes
                  await _databaseService.updateUserInDatabase(appUser, dto);

                  // go back home
                  _navigationService.navigationClearStack(context);
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

  // Get image for profile Image
  void getProfileImage(BuildContext context) async {
    String url = await _navigationService.navigateToUploadScreen(context);

    if (url.isNotEmpty) {
      // print('Image successfully uploaded for user profile');
      setState(() {
        // print('before ${dto.profileImageUrl}');
        this.dto.profileImageUrl = url;
        // print(dto.profileImageUrl);
      });
    } else {
      // print('No new image');
    }
  }
}
