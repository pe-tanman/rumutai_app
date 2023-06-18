import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumutai_app/screens/staff/my_place_game_screen.dart';
import '/providers/local_data.dart';
import 'package:provider/provider.dart';
import "/providers/dashboard_data.dart";

class DashboardWidget extends StatefulWidget {
  String staffPlace;
  double x;
  double y;

  DashboardWidget(this.staffPlace, this.x, this.y);

  @override
  State<DashboardWidget> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardWidget> {
  bool isloading = true;
  late String staffPlace;
  late double x;
  late double y;

  late String localPlace;
  late Color signColor;

  @override
  void initState() {
    staffPlace = widget.staffPlace;
    x = widget.x;
    y = widget.y;

    LoadPlace();
    ChangeButtonColor();
  }

  Future<void> ChangeButtonColor() async {
    var globalData = await FirebaseFirestore.instance
        .collection("StaffDashboard")
        .doc(staffPlace)
        .get();
    int currentStaffs = globalData.get("staffs");

    if (staffPlace == "本部") {
      if (currentStaffs > 8) {
        signColor = Colors.green;
      } else if (currentStaffs > 5) {
        signColor = Colors.yellow;
      } else {
        signColor = Colors.red;
      }
    } else {
      if (currentStaffs > 0) {
        signColor = Colors.green;
      } else {
        signColor = Colors.red;
      }
    }
    setState(() {
      isloading = false;
    });
    print("$staffPlace  $signColor");
  }

  Future<void> LoadPlace() async {
    localPlace = await LocalData.readLocalData<String>("staffPlace");

    print("$staffPlace  $localPlace");
  }

  Widget _dialogIn({required String staffPlace}) {
    bool dialogIsLoading = false;
    return StatefulBuilder(
      builder: (context, setStateInDialog) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text("確認"),
          content: SizedBox(
              height: 50, width: 200, child: Text("$staffPlace　のスタッフを担当します")),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            if (!dialogIsLoading)
              SizedBox(
                width: 140,
                height: 40,
                child: OutlinedButton(
                  style:
                      OutlinedButton.styleFrom(foregroundColor: Colors.black),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("キャンセル"),
                ),
              ),
            if (!dialogIsLoading)
              SizedBox(
                width: 140,
                height: 40,
                child: FilledButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Text("確認"),
                    onPressed: () async {
                      await LocalData.saveLocalData<String>(
                          "staffPlace", staffPlace);

                      var d = await FirebaseFirestore.instance
                          .collection("StaffDashboard")
                          .doc(staffPlace)
                          .get();
                      var data = {"staffs": d.get("staffs") + 1};
                      await FirebaseFirestore.instance
                          .collection('StaffDashboard')
                          .doc(staffPlace)
                          .set(data, SetOptions(merge: true));

                      Navigator.pop(context);

                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return _dialogOut(staffPlace: staffPlace);
                          });
                      Navigator.of(context).pushNamed(
                          MyPlaceGameScreen.routeName,
                          arguments: staffPlace);
                    }),
              )
          ],
        );
      },
    );
  }

  Widget _dialogOut({required String staffPlace}) {
    bool dialogIsLoading = false;
    return StatefulBuilder(
      builder: (context, setStateInDialog) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: const Text("確認"),
              content: SizedBox(
                  height: 50, width: 200, child: Text("$staffPlace　の担当を外れます")),
              actionsAlignment: MainAxisAlignment.center,
              actions: <Widget>[
                if (!dialogIsLoading)
                  SizedBox(
                    width: 140,
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            MyPlaceGameScreen.routeName,
                            arguments: staffPlace);
                      },
                      child: const Text("キャンセル"),
                    ),
                  ),
                if (!dialogIsLoading)
                  SizedBox(
                    width: 140,
                    height: 40,
                    child: FilledButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: const Text("確認"),
                        onPressed: () async {
                          LocalData.saveLocalData<String>("staffPlace", "None");
                          var d = await FirebaseFirestore.instance
                              .collection("StaffDashboard")
                              .doc(staffPlace)
                              .get();
                          var data = {"staffs": d.get("staffs") - 1};
                          if (d.get("staffs") >= 1) {
                            await FirebaseFirestore.instance
                                .collection('StaffDashboard')
                                .doc(staffPlace)
                                .set(data, SetOptions(merge: true));
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('担当を外れました'),
                          ));
                          Navigator.pop(context);
                        }),
                  )
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardNotifier>(
        builder: (context, dashboardNotifier, child) {
      // 必要に応じて状態を更新する
      if (dashboardNotifier.needsUpdate) {
        isloading = true;
        LoadPlace();
        ChangeButtonColor();

        dashboardNotifier.resetNeedsUpdate();
      }
      if (isloading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        if (localPlace == staffPlace) {
          print("dialog_out");
          return _dialogOut(staffPlace: staffPlace);
        }
        ;
      }
      return Align(
          alignment: Alignment(x, y),
          child: ElevatedButton(
            onPressed: () {
              if (localPlace == "None") {
                showDialog(
                    context: context,
                    builder: (_) {
                      return _dialogIn(staffPlace: staffPlace);
                    });
              } else if (localPlace == staffPlace) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return _dialogOut(staffPlace: staffPlace);
                    });
              } else {
                null;
              }
            },
            child: Text(
                (staffPlace == localPlace) ? "$staffPlace(担当中)" : staffPlace),
            style: ElevatedButton.styleFrom(backgroundColor: signColor),
          ));
    });
  }
}
