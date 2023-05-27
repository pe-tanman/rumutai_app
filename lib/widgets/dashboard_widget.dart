import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    var globalData =
        await FirebaseFirestore.instance.collection("StaffDashboard").get();
    var d = globalData.docs[0].data();

    if (staffPlace == "本部") {
      if (d[staffPlace] > 8) {
        signColor = Colors.green;
      } else if (d[staffPlace] > 5) {
        signColor = Colors.yellow;
      } else {
        signColor = Colors.red;
      }
    } else {
      if (d[staffPlace] > 0) {
        signColor = Colors.green;
      } else {
        signColor = Colors.red;
      }
    }
    if ((localPlace != staffPlace) && (localPlace != "None")) {
      signColor = Colors.grey;
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
              height: 50,
              width: 200,
              child: dialogIsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text("$staffPlace　のスタッフを担当します")),
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
                      var globalData = await FirebaseFirestore.instance
                          .collection("StaffDashboard")
                          .get();
                      var d = globalData.docs[0].data();
                      var data = {staffPlace: d[staffPlace] + 1};
                      await FirebaseFirestore.instance
                          .collection('StaffDashboard')
                          .doc("Place")
                          .set(data, SetOptions(merge: true));
                      setState(() {
                        LoadPlace();
                        ChangeButtonColor();
                      });

                      Provider.of<DashboardNotifier>(context, listen: false)
                          .updateDashboard();
                      Navigator.of(context).pushNamed(
                          '/dashboard-detail-screen',
                          arguments: staffPlace);
                    }),
              ),
          ],
        );
      },
    );
  }

  static Widget _dialogOut({required String staffPlace}) {
    bool dialogIsLoading = false;
    return StatefulBuilder(
      builder: (context, setStateInDialog) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text("確認"),
          content: SizedBox(
              height: 50,
              width: 200,
              child: dialogIsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text("$staffPlace　のスタッフを外れます")),
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
                      LocalData.saveLocalData<String>("staffPlace", "None");
                      var globalData = await FirebaseFirestore.instance
                          .collection("StaffDashboard")
                          .get();
                      var d = globalData.docs[0].data();
                      var data = {staffPlace: d[staffPlace] - 1};
                      await FirebaseFirestore.instance
                          .collection('StaffDashboard')
                          .doc("Place")
                          .set(data, SetOptions(merge: true));
                      Provider.of<DashboardNotifier>(context, listen: false)
                          .updateDashboard();
                      Navigator.of(context).pushNamed('/home-screen');
                    }),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("built");
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
        return Align(
            alignment: Alignment(x, y),
            child: TextButton(
                onPressed: (localPlace == "None" || localPlace == staffPlace)
                    ? () {
                        if (localPlace == "None") {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return _dialogIn(staffPlace: staffPlace);
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return _dialogOut(staffPlace: staffPlace);
                            },
                          );
                        }
                      }
                    : null,
                child: Text(
                  (staffPlace == localPlace) ? "$staffPlace(担当中)" : staffPlace,
                  style: TextStyle(color: signColor, fontSize: 20),
                )));
      }
    });
  }
}
