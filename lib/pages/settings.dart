import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appTheme = context.watch<AppTheme>();
    var appColors = appTheme.appColors;
    var darkMode = appTheme.darkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1,
            ),
            children: [
              for (bool? i in [false, true, null])
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => appTheme.setDarkMode(i),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            darkMode == i ? appTheme.color : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: appTheme.color),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 7),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  Theme.of(context).cardColor.withOpacity(0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  i == null
                                      ? Icons.brightness_4_rounded
                                      : (i
                                          ? Icons.brightness_2_rounded
                                          : Icons.brightness_5_rounded),
                                  size: 20,
                                ),
                                Text(i == null
                                    ? 'Auto'
                                    : (i ? 'Dark' : 'Light')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Primary Color'),
        ),
        Expanded(
          flex: 7,
          child: GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              childAspectRatio: 1 / 1,
            ),
            children: [
              for (var appColor in appColors)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (appColor == appTheme.color)
                        ? null
                        : () => appTheme.setColor(appColor),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: appColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: (appColor == appTheme.color) ? 1 : 0,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.5),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
