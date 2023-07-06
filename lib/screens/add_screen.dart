import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intagram/providers/user_provider.dart';
import 'package:intagram/resource/firestore_methods.dart';
import 'package:intagram/ultils/colors.dart';
import 'package:intagram/ultils/ultils.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Uint8List? _image;
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  String res = '';

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a picture'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _image = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _image = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  postImage(
    String description,
    Uint8List file,
    String uid,
    String userName,
    String profImage,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      res = await FirestoreMethods()
          .uploadPost(description, file, uid, userName, profImage);

      if (res == 'success') {
        showSnackbar('posted!', context);
        clearImage();
      } else {
        showSnackbar(res, context);
      }
    } catch (err) {
      showSnackbar(err.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  clearImage() {
    _image = null;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getuser;
    return _image == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                size: 40,
              ),
              onPressed: () {
                _selectImage(context);
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
              actions: [
                TextButton(
                  onPressed: () {
                    postImage(_descriptionController.text, _image!, user!.uid,
                        user.username, user.imageUrl);
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: _isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user!.imageUrl),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                hintText: 'Write a caption...',
                                border: InputBorder.none,
                              ),
                              maxLines: 8,
                            ),
                          ),
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: MemoryImage(_image!),
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.topCenter),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
          );
  }
}
