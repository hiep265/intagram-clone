import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intagram/resource/firestore_methods.dart';
import 'package:intagram/ultils/colors.dart';
import 'package:intagram/ultils/ultils.dart';

import '../wigets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int lengthPost = 0;
  bool isFollowing = false;
  bool isLoading = false;
  int follower = 0;
  int following = 0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snap.data()!;
      follower = userData['followers'].length;
      following = userData['followings'].length;
      var postData = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      lengthPost = postData.docs.length;
      isFollowing = snap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout))
              ],
              title: Text(userData['username']),
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    NetworkImage(userData['photourl']),
                                radius: 40,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              userData['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            alignment: Alignment.centerLeft,
                            child: Text(userData['bio']),
                          )
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                buildInforUser(lengthPost.toString(), 'posts'),
                                buildInforUser(
                                    follower.toString(), 'followers'),
                                buildInforUser(
                                    following.toString(), 'followings')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        backgroundColor: mobileBackgroundColor,
                                        text: 'edit profile',
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        function: () {},
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            function: () async {
                                              await FirestoreMethods().unFollow(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  widget.uid);
                                              await FirestoreMethods()
                                                  .UnFollowing(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.uid);
                                              setState(() {
                                                isFollowing = false;
                                                follower--;
                                              });
                                            },
                                            backgroundColor: Colors.white,
                                            borderColor: Colors.grey,
                                            text: 'Unfollow',
                                            textColor: Colors.black)
                                        : FollowButton(
                                            function: () async {
                                              await FirestoreMethods().follow(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  widget.uid);
                                              await FirestoreMethods()
                                                  .Following(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.uid);
                                              setState(() {
                                                isFollowing = true;

                                                follower++;
                                              });
                                            },
                                            backgroundColor: Colors.blue,
                                            borderColor: Colors.blue,
                                            text: 'follow',
                                            textColor: Colors.white)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = snapshot.data!.docs[index];
                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildInforUser(String num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
