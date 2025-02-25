// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool isLookingBlue;
  String title;
  double height;
  bool color;
  bool showCheckSave;
  bool isBackButtonThere;
  bool isActionButtonsThere;

  CustomAppBar(
      {super.key,
      this.isLookingBlue = false,
      this.isBackButtonThere = true,
      this.title = "",
      this.color = false,
      this.showCheckSave = false,
      this.isActionButtonsThere = false,
      this.height = 60});

  @override
  Widget build(BuildContext context) {
    final IconButton leadingWidget = IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: isLookingBlue
            ? Colors.white
            : Theme.of(context).colorScheme.secondary,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    if (ModalRoute.of(context)!.canPop == true) {
      isBackButtonThere = true;
    } else {
      isBackButtonThere = false;
    }

    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      leading: isBackButtonThere ? leadingWidget : null,
      backgroundColor: color ? Colors.white : Colors.transparent,
      foregroundColor: isLookingBlue
          ? Colors.white
          : Theme.of(context).colorScheme.secondary,
      elevation: 0,
      actions: [
        showCheckSave
            ? IconButton(onPressed: () {}, icon: const Icon(Icons.check))
            : const SizedBox(),
        isActionButtonsThere
            ? IconButton(onPressed: () {}, icon: const Icon(Icons.search))
            : const SizedBox()
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class CustomAppBarAndSave extends StatelessWidget
    implements PreferredSizeWidget {
  bool isLookingBlue;
  String title;
  double height;
  bool color;
  bool showCheckSave;
  Function save;
  bool isLoadingData;
  bool isActionButtonsThere;

  CustomAppBarAndSave(
      {super.key,
      this.isLookingBlue = false,
      this.title = "",
      this.color = false,
      this.showCheckSave = false,
      required this.save,
      this.isLoadingData = false,
      this.isActionButtonsThere = false,
      this.height = 60});

  @override
  Widget build(BuildContext context) {
    final IconButton leadingWidget;
    if (Platform.isAndroid) {
      leadingWidget = IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isLookingBlue
                ? Colors.white
                : Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          });
    } else {
      leadingWidget = IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isLookingBlue
              ? Colors.white
              : Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      leading: leadingWidget,
      backgroundColor: color ? Colors.white : Colors.transparent,
      foregroundColor: isLookingBlue
          ? Colors.white
          : Theme.of(context).colorScheme.secondary,
      elevation: 0,
      actions: [
        showCheckSave
            ? isLoadingData
                ? const Padding(
                    padding: EdgeInsets.all(13),
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ))
                : IconButton(
                    onPressed: () => save(), icon: const Icon(Icons.check))
            : const SizedBox(),
        isActionButtonsThere
            ? IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.black),
              )
            : const SizedBox()
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
