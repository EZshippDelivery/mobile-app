// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:ezshipp/utils/themes.dart';
import 'package:ezshipp/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class TabBars {
  static List tab = [
    ["Sign In", Icons.person],
    ["Sign Up", Icons.person_add_alt_1]
  ];
  static List tab1 = [
    ["New orders", LineIcons.box],
    ["My orders", LineIcons.boxes]
  ];

  static List tab2 = [
    Image.asset("assets/icon/shiping.png"),
    Image.asset(
      "assets/icon/icons8-task-completed-50.png",
      height: 25,
    )
  ];
  static List<Widget> tabs = [
    for (final name in tab)
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(name[1]),
        const SizedBox(
          width: 10,
        ),
        Text(name[0])
      ])
  ];
  static List<Widget> tabs1(TabController controller) => [
        for (final name in tab1)
          Tab(
            text: controller.index == tab1.indexOf(name) ? name[0] : null,
            icon: Icon(name[1]),
            iconMargin: const EdgeInsets.all(0),
            height: 47,
          )
      ];

  static List<Widget> tabs2(int count) => [
        Tab(
          icon: tab2[0],
          iconMargin: const EdgeInsets.all(0),
          height: 45,
        ),
        SizedBox(
          width: 30,
          child: Stack(
            children: [
              Tab(
                icon: tab2[1],
                iconMargin: const EdgeInsets.all(0),
                height: 45,
              ),
              if (count > 0)
                Positioned(
                    top: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Palette.deepgrey,
                      radius: 10,
                      child: Text(
                        count.toString(),
                        style: Variables.font(color: Colors.white, fontSize: 10),
                      ),
                    ))
            ],
          ),
        )
      ];

  static List<Widget> tabs3 = [Text("Accepted", style: Variables.font()), Text("Delivered", style: Variables.font())];
}
