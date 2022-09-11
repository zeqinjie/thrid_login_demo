/*
 * @Author: zhengzeqin
 * @Date: 2022-09-01 16:44:22
 * @LastEditTime: 2022-09-11 14:37:27
 * @Description: your project
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String txt = '';

  /// 谷歌的用户端编号
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'xxxxxxx-xxxxxxxxxxxxx.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                txt,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            _buildButton(
              title: 'line',
              color: Colors.green,
              click: lineLoginHandler,
            ),
            _buildButton(
              title: 'google',
              color: Colors.orange,
              click: googleLoginHandler,
            ),
            _buildButton(
              title: 'facebook',
              color: Colors.blue,
              click: facebookLoginHandler,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required Color color,
    VoidCallback? click,
  }) {
    return SizedBox(
      width: 100,
      child: TextButton(
        onPressed: click,
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(color),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// line 登录
  void lineLoginHandler() async {
    try {
      final result = await LineSDK.instance.login();
      final userId = result.userProfile?.userId;
      final name = result.userProfile?.displayName;
      final avatar = result.userProfile?.pictureUrl;
      print('userId: $userId name: $name avatar: $avatar');
      setState(() {
        txt = 'userId: $userId name: $name avatar: $avatar';
      });
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  /// line 登出
  void lineLoginOutHandler() async {
    try {
      await LineSDK.instance.logout();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  /// google 登录
  void googleLoginHandler() async {
    try {
      final result = await _googleSignIn.signIn();
      final userId = result?.id;
      final name = result?.displayName;
      final email = result?.email;
      final avatar = result?.photoUrl;
      print('userId: $userId name: $name email: $email avatar: $avatar');
      setState(() {
        txt = 'userId: $userId name: $name email: $email avatar: $avatar';
      });
    } catch (error) {
      print(error);
    }
  }

  /// google 登出
  void googleLoginOutHandler() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }

  /// facebook 登录
  void facebookLoginHandler() async {
    final fb = FacebookLogin();

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken;
        print('Access token: ${accessToken?.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) print('And your email is $email');
        setState(() {
          txt =
              'userId: ${profile?.userId} name: ${profile?.name} email: $email avatar: $imageUrl';
        });

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  /// facebook 登出
  void facebookLoginOutHandler() async {
    try {
      final fb = FacebookLogin();
      await fb.logOut();
    } catch (error) {
      print(error);
    }
  }
}
