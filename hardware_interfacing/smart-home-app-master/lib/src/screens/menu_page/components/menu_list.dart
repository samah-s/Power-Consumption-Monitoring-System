import 'package:domus/src/screens/menu_page/components/list_tile.dart';
import 'package:domus/src/screens/stats_screen/stats_screen.dart';
import 'package:domus/src/screens/savings_screen/savings_screen.dart';
import 'package:flutter/material.dart';
import 'package:domus/config/size_config.dart';
import 'package:domus/src/screens/llm_screen/body.dart';
import 'package:domus/src/add_remove/DeviceManagementPage.dart';

class MenuList extends StatelessWidget {
  const MenuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //MenuListItem is custom tile in list_tile file
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/stats.svg',
          itemName: 'Stats',
          function: () => Navigator.of(context).pushNamed(
            StatsScreen.routeName,
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/devices.svg',
          itemName: 'Devices',
          function: () => Navigator.pushNamed(context, DeviceManagementScreen.routeName),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/savings.svg',
          itemName: 'Savings',
          function: () {
            Navigator.of(context).pushNamed(SavingsScreen.routeName);
          },
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/settings.svg',
          itemName: 'Data Analytics',
          function: () => Navigator.of(context).pushNamed(LLMAnalysisScreen.routeName),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/notifications.svg',
          itemName: 'Notification',
          function: () {},
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/faq.svg',
          itemName: 'FAQ',
          function: () {},
        ),
      ],
    );
  }
}
