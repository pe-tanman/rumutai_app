
import 'package:flutter/material.dart';
import 'package:rumutai_app/screens/schedule/place_schedule_screen.dart';
import 'package:rumutai_app/themes/app_color.dart';

class PickPlaceScheduleScreen extends StatefulWidget {
  const PickPlaceScheduleScreen({super.key});

  static const routeName = "/pick-place-schedule-screen";

  @override
  State<PickPlaceScheduleScreen> createState() =>
      _PickPlaceScheduleScreenState();
}

class _PickPlaceScheduleScreenState extends State<PickPlaceScheduleScreen> {
  final _viewTransformationController = TransformationController();

  Widget _placeScheduleButton(placeName, double x, double y) {
    return Align(
        alignment: Alignment(x, y),
          child:Card(
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: AppColors.themeColor,
                width: 1, 
              ),
            ),
            child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(PlaceScheduleScreen.routeName,
                  arguments: placeName);
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100, maxWidth : 170),
              child: SizedBox(
                height: 70,
                child: Center(
                  child: Text(
                    (placeName),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("場所別スケジュール")),
        body: Stack(children: [
          Center(
            child: InteractiveViewer(
              transformationController: _viewTransformationController,
              maxScale: 5,
              child: Image.asset("assets/images/map_background.png"),
            ),
          ),
          const Text("※場所名をタップするとスケジュールが確認できます"),
          _placeScheduleButton("外バレ北", -0.65, -0.94),
          _placeScheduleButton("外バレ南", -0.65, -0.75),
          _placeScheduleButton("鯱光館東", 1, -0.4),
          _placeScheduleButton("鯱光館西", -0.4, -0.4),
          _placeScheduleButton("小体育館", -1, 0.1),
          _placeScheduleButton("ハンドボールコート", -1, 0.42),
          _placeScheduleButton("運動場A", 0.7, 0.42),
          _placeScheduleButton("運動場B", 0.7, 0.67),
          _placeScheduleButton("運動場C", 0.7, 0.92),
        ]));
  }
}
