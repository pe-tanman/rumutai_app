import 'package:flutter/material.dart';
import 'package:rumutai_app/widgets/dashboard_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = "/dashboard-screen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _viewTransformationController = TransformationController();

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
          DashboardWidget("外バレーコート北", -0.6, -0.95),
          DashboardWidget("外バレーコート南", -0.6, -0.80),
          DashboardWidget("本部", 0.3, -0.25),
          DashboardWidget("鯱光館東", 0.6, -0.55),
          DashboardWidget("鯱光館西", 0, -0.55),
          DashboardWidget("小体育館", -0.8, -0.3),
          DashboardWidget("小体育館Ⅰ", -0.8, -0.15),
          DashboardWidget("小体育館Ⅱ", -0.8, 0),
          DashboardWidget("小体育館Ⅲ", -0.8, 0.15),
          DashboardWidget("ハンドボールコート", -0.8, 0.4),
          DashboardWidget("運動場A", 0.3, 0.4),
          DashboardWidget("運動場B", 0.3, 0.6),
          DashboardWidget("運動場C", 0.3, 0.8),
        ]));
  }
}
