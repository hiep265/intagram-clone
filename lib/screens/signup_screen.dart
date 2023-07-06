import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intagram/resource/auth_methos.dart';
import 'package:intagram/ultils/ultils.dart';
import 'package:intagram/wigets/textfield_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  final usernameController = TextEditingController();
  Uint8List? image;
  bool _isloading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  void signupUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethos().signupUser(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        bio: bioController.text,
        file: image);
    setState(() {
      _isloading = false;
    });
    if (res != 'success') {
      showSnackbar(res, context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget selectIm = image == null
        ? const CircleAvatar(
            radius: 64,
            backgroundImage:
                AssetImage('assets/avatar-co-nang-toc-ngan-700x700.jpg'),
          )
        : CircleAvatar(
            radius: 64,
            backgroundImage: MemoryImage(image!),
          );
    return Scaffold(
      body: SafeArea(
        child: _isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(),
                      flex: 2,
                    ),
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: Colors.white,
                      height: 64,
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    Stack(
                      children: [
                        selectIm,
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextfieldInput(
                      textEditingController: usernameController,
                      hintText: 'Enter your username',
                      ispass: false,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextfieldInput(
                      textEditingController: emailController,
                      hintText: 'Enter your email',
                      ispass: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextfieldInput(
                      textEditingController: passwordController,
                      hintText: 'Enter your password',
                      ispass: true,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextfieldInput(
                      textEditingController: bioController,
                      hintText: 'Enter your bio',
                      ispass: false,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: signupUser,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text('Signup'),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text('I have an account! '),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              ' Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
