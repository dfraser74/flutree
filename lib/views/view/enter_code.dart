import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../CONSTANTS.dart';
import '../../utils/snackbar.dart';
import '../../utils/urlLauncher.dart';
import '../auth/signin.dart';
import '../widgets/reuseable.dart';
import 'user_card.dart';

enum PlatformTarget { Browser, PlayStore }

class EnterCode extends StatefulWidget {
  EnterCode({this.userCode});
  final String userCode;
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();

  final _authInstance = FirebaseAuth.instance;

  bool isLoading = false;

  bool hasTryAccessProfile = false;

  void accessProfile(String code) async {
    setState(() {
      isLoading = true;
      hasTryAccessProfile = true;
    });
    try {
      if (_authInstance.currentUser == null) {
        await _authInstance.signInAnonymously();
      } else {
        print('Using previous credential');
      }
      _usersCollection.doc(code).get().then((value) {
        print('snapshot is ${value.data()}');
        setState(() => isLoading = false);
        if (value.exists) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => UserCard(value)));
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: NotFoundDialog(),
              );
            },
          );
        }
      });
    } on FirebaseAuthException catch (error) {
      print('Error: $error');
      CustomSnack.showErrorSnack(context, message: 'Error: ${error.message}');
      setState(() => isLoading = false);
    } catch (e) {
      print('Unknown error: $e');
      setState(() => isLoading = false);
      CustomSnack.showErrorSnack(context, message: 'Unknown err.');
    }
  }

  @override
  Widget build(BuildContext context) {
    _codeController.text = widget.userCode;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!hasTryAccessProfile && widget.userCode.isNotEmpty) {
        print(widget.userCode);
        accessProfile(widget.userCode.trim());
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/logo/applogo.png', width: 100),
                  Text('Enter Flutree code', style: TextStyle(fontSize: 28)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 60.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        validator: (value) =>
                            value.length < 5 ? 'Not enough character' : null,
                        controller: _codeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate()) {
                        accessProfile(_codeController.text.trim());
                      }
                    },
                    child: !isLoading ? Text('Go') : LoadingIndicator(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () async {
                      PlatformTarget target = await platformChooser(context);

                      if (target == PlatformTarget.Browser) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      } else if (target == PlatformTarget.PlayStore) {
                        launchURL(context, kPlayStoreUrl);
                      } else {
                        return;
                      }
                    },
                    child: Text('Make your own Flutree profile!',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.orange.shade700,
                            decorationStyle: TextDecorationStyle.dotted,
                            decoration: TextDecoration.underline)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<PlatformTarget> platformChooser(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 170,
          child: Column(
            children: [
              Expanded(
                child: SizedBox.expand(
                  child: TextButton.icon(
                      icon: FaIcon(FontAwesomeIcons.googlePlay),
                      onPressed: () =>
                          Navigator.of(context).pop(PlatformTarget.PlayStore),
                      label: Text(
                        'Get app from Google Play Store\n(Recommended)',
                        maxLines: 3,
                      )),
                ),
              ),
              Expanded(
                child: SizedBox.expand(
                  child: TextButton.icon(
                      icon: FaIcon(FontAwesomeIcons.chrome),
                      onPressed: () =>
                          Navigator.of(context).pop(PlatformTarget.Browser),
                      label: Text(
                        'Continue on browser\n(Beta)',
                        maxLines: 3,
                      )),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class NotFoundDialog extends StatelessWidget {
  const NotFoundDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/undraw_page_not_found_su7k.png',
              width: 400,
            ),
          ),
          Text(
              'User not found. Please try again or check the code if entered correctly.')
        ],
      ),
    );
  }
}
