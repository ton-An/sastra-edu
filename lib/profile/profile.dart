/*
 * Name: profile
 * Use:
 * TODO:    - Add Use of this file
            - cleanup
 */

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sastra_ebooks/components/appBarTitles/appBarTitle.dart';
import 'package:sastra_ebooks/components/customAppBar.dart';
import 'package:sastra_ebooks/components/customScaffold.dart';
import 'package:sastra_ebooks/components/listItem.dart';
import 'package:sastra_ebooks/components/profile/profileInfoCard.dart';
import 'package:sastra_ebooks/components/profile/profilePicture.dart';
import 'package:sastra_ebooks/misc/screens/mailUs.dart';
import 'package:sastra_ebooks/misc/strings.dart';
import 'package:sastra_ebooks/services/responsive/sizeConfig.dart';
import 'package:sastra_ebooks/services/user.dart';

import 'settingScreens/about.dart';
import 'settingScreens/buyACoke.dart';
import '../services/dialogs.dart';

class Profile extends StatefulWidget {
  static const String id = '/profile';

  final User user;

  Profile(this.user);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future uploadingPicInProgress;
  bool isPopping = false;
  Future<void> getImage(BuildContext context) async {
    PickedFile pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 30,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedImage != null) {
      print("Image path $pickedImage");

      bool dialogResult = await Dialogs.areYouSureDialog(context,
          title: 'Are you sure?',
          description:
              'You won\'t be able to recover your old profile picture');

      if (dialogResult)
        uploadingPicInProgress = uploadPic(pickedImage);
      else
        File(pickedImage.path).delete();
    }
  }

  Future uploadPic(PickedFile pickedImage) async {
    ProfilePicture.updateImage('placeholder');

    if (!isPopping) {
      setState(() {});
    }
    String imagePath = 'images/proPics/${basename(pickedImage.path)}';
    StorageReference oldProPicReference;

    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imagePath);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(
      File(pickedImage.path),
    );

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    if (taskSnapshot.error == null) {
      oldProPicReference = await FirebaseStorage.instance
          .getReferenceFromUrl(widget.user.proPicUrl);

      widget.user.proPicUrl = await taskSnapshot.ref.getDownloadURL();

      Firestore.instance.document("Data/${widget.user.uid}").updateData({
        "pro_pic": widget.user.proPicUrl,
      });
      print(widget.user.proPicUrl);
    }

    print("Profile Picture uploaded");

    oldProPicReference.delete();
    File(pickedImage.path).delete();
    print(isPopping);
    ProfilePicture.updateImage(widget.user.proPicUrl);

    if (!isPopping) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    void onPop() {
      isPopping = true;
      Navigator.pop(context, uploadingPicInProgress);
    }

    return WillPopScope(
      onWillPop: () {
        onPop();
        return Future.value(true);
      },
      child: CustomScaffold(
        appBar: CustomAppBar(
          context,
          backButton: true,
          onBackButtonPressed: onPop,
          title: AppBarTitle('Profile'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 10,
              child: Center(
                child: ProfileInfoCard(widget.user, getImage),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ListItem(
                  onPressed: () => Navigator.pushNamed(context, MailUs.id),
                  title: Strings.supportString,
                  icon: Icons.feedback,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                ListItem(
                  onPressed: () => Navigator.pushNamed(context, AboutUs.id),
                  title: Strings.aboutUsString,
                  icon: Icons.person,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                ListItem(
                  onPressed: () => Navigator.pushNamed(context, BuyACoke.id),
                  title: Strings.donationString,
                  icon: Icons.card_giftcard,
//                    SvgPicture.asset(
//                      Images.coke,
//                      color: Colors.lightBlueAccent,
//                      height: 20.0,
//                    ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
