import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/widgets/my_game_widget.dart';
import '/widgets/main_pop_up_menu.dart';
import '/widgets/dashboard_widget.dart';
import "/providers/local_data.dart";

class DashboardDetailScreen extends StatefulWidget {
  static const routeName = "/dashboard-detail-screen";

  const DashboardDetailScreen({super.key});

  @override
  State<DashboardDetailScreen> createState() => _DashboardDetailState();
}

class _DashboardDetailState extends State<DashboardDetailScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  //bool _dialogIsLoading = false;
  //bool _dialogIsInit = true;
  bool _isDirty = false;
  List<Map> _gameDataList = [];

  Object? _targetPlace;
  String? targetPlace;

  Future _loadData() async {
    targetPlace = _targetPlace as String;
    print(targetPlace);
    if ((_isInit && targetPlace != null) || _isDirty) {
      setState(() {
        _isLoading = true;
      });
      _gameDataList = [];
      await FirebaseFirestore.instance
          .collection('gameData')
          .where('place', isEqualTo: targetPlace)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _gameDataList.add(doc.data() as Map);
        }

        print(_gameDataList[0]);
      });
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
      _isDirty = false;
    }
  }

  Widget _dividerWithText(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          SizedBox(
              width: 40,
              child: Divider(
                thickness: 1,
                color: Colors.brown.shade800,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.brown.shade800,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.brown.shade800,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _myGameListWidget({required List<Map> gameDataList}) {
    List<Widget> myGameListWidget = [];
    List day1sortedMyGameData = [];
    List day2sortedMyGameData = [];
    for (var gameData in gameDataList) {
      if (gameData["startTime"]["date"] == "1") {
        day1sortedMyGameData.add({
          "createdAt": DateTime(
            2023,
            3,
            15,
            int.parse(gameData["startTime"]["hour"]),
            int.parse(gameData["startTime"]["minute"]),
          ),
          "data": gameData
        });
      } else if (gameData["startTime"]["date"] == "2") {
        day2sortedMyGameData.add({
          "createdAt": DateTime(
            2023,
            3,
            16,
            int.parse(gameData["startTime"]["hour"]),
            int.parse(gameData["startTime"]["minute"]),
          ),
          "data": gameData
        });
      }
    }

    if (day1sortedMyGameData.isEmpty && day2sortedMyGameData.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "試合なし",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              color: Colors.brown.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ];
    }

    day1sortedMyGameData
        .sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
    day2sortedMyGameData
        .sort((a, b) => a['createdAt'].compareTo(b['createdAt']));

    myGameListWidget.add(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Text(
          "※タップで詳細を確認できます。",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.brown.shade700,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );

    myGameListWidget.add(_dividerWithText("1日目"));
    for (var element in day1sortedMyGameData) {
      myGameListWidget.add(MyGameWidget(
        gameData: element["data"],
      ));
    }
    myGameListWidget.add(_dividerWithText("2日目"));
    for (var element in day2sortedMyGameData) {
      myGameListWidget.add(MyGameWidget(
        gameData: element["data"],
      ));
    }
    return myGameListWidget;
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
    _targetPlace = ModalRoute.of(context)!.settings.arguments;
    _loadData();

    return WillPopScope(
        onWillPop: () async {
          showDialog(
            context: context,
            builder: (_) {
              return _dialogOut(staffPlace: targetPlace);
            },
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("担当の試合"),
            actions: const [MainPopUpMenu()],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          targetPlace == null ? "担当場所：" : "担当場所：$targetPlace",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                            child: Column(
                          children: _myGameListWidget(
                            gameDataList: _gameDataList,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
        ));

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
  }
}

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        '←',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
      onPressed: () {},
    );
  }
}
