import 'package:flutter/material.dart';
import 'package:intagram/providers/user_provider.dart';
import 'package:intagram/responsive/dimentions.dart';
import 'package:provider/provider.dart';

class Responsivelayout extends StatefulWidget {
  final Widget WebScreenLayout;
  final Widget MobileScreenLayout;
  const Responsivelayout(
      {super.key,
      required this.WebScreenLayout,
      required this.MobileScreenLayout});

  @override
  State<Responsivelayout> createState() => _ResponsivelayoutState();
}

class _ResponsivelayoutState extends State<Responsivelayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return widget.WebScreenLayout;
        }
        return widget.MobileScreenLayout;
      },
    );
  }
}
