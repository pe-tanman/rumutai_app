import 'package:flutter/material.dart';
import 'package:rumutai_app/screens/schedule/place_schedule_screen.dart';

class PickPlaceScheduleScreen extends StatefulWidget {
  const PickPlaceScheduleScreen({super.key});

  static const routeName = "/pick-place-schedule-screen";

  @override
  State<PickPlaceScheduleScreen> createState() => _PickPlaceScheduleScreenState();
}

class _PickPlaceScheduleScreenState extends State<PickPlaceScheduleScreen> {
  final _viewTransformationController = TransformationController();

  Widget _placeScheduleButton(placeName, double x, double y) {
    return Align(
        alignment: Alignment(x, y),
        child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(PlaceScheduleScreen.routeName,
                  arguments: placeName);
            },
            child: Text(
              (placeName),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("人手確認")),
        body: Stack(children: [
          Center(
            child: InteractiveViewer(
              transformationController: _viewTransformationController,
              maxScale: 5,
              child: Image.asset("assets/images/dashboard_background.png"),
            ),
          ),
           _placeScheduleButton("外バレ北", -0.6, -0.95),
           _placeScheduleButton("外バレ南", -0.6, -0.80),
           _placeScheduleButton("鯱光館東", 0.7, -0.55),
           _placeScheduleButton("鯱光館西", 0, -0.55),
           _placeScheduleButton("小体育館", -0.8, -0.3),
           _placeScheduleButton("ハンドボールコート", -0.8, 0.4),
           _placeScheduleButton("運動場A", 0.3, 0.4),
           _placeScheduleButton("運動場B", 0.3, 0.6),
           _placeScheduleButton("運動場C", 0.3, 0.8),
        ]));
  }
}
