import 'package:flutter/material.dart';
import 'package:rumutai_app/widgets/dashboard_widget.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard-screen";

  DashboardScreen({
    super.key,
  });

  final _viewTransformationController = TransformationController();

  void _setMapToView(String? place) {
    if (place == null) {
      return;
    }
    late double zoomFactor;
    late double xTranslate;
    late double yTranslate;
    if (place.contains("運動場")) {
      zoomFactor = 2.3;
      xTranslate = 395.0;
      yTranslate = 540.0;
    } else if (place.contains("鯱光館")) {
      zoomFactor = 2.4;
      xTranslate = 380.0;
      yTranslate = 300.0;
    } else if (place.contains("外バレ")) {
      zoomFactor = 3.0;
      xTranslate = 450.0;
      yTranslate = 380.0;
    } else if (place.contains("小体育館")) {
      zoomFactor = 3.0;
      xTranslate = 0.0;
      yTranslate = 700.0;
    } else {
      return;
    }
    _viewTransformationController.value.setEntry(0, 0, zoomFactor);
    _viewTransformationController.value.setEntry(1, 1, zoomFactor);
    _viewTransformationController.value.setEntry(2, 2, zoomFactor);
    _viewTransformationController.value.setEntry(0, 3, -xTranslate);
    _viewTransformationController.value.setEntry(1, 3, -yTranslate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ダッシュボード")),
        body: Stack(children: [
          Center(
            child: InteractiveViewer(
              transformationController: _viewTransformationController,
              maxScale: 5,
              child: Image.asset("assets/images/dashboard_background.png"),
            ),
          ),
          DashboardWidget("外バレーコート北", -0.6, -0.95),
          DashboardWidget("外バレーコート南", -0.6, -0.80),
          DashboardWidget("鯱光館東", 0.3, -0.25),
        ]));
  }
}
