import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rumutai_app/utilities/sport_utilities.dart';
import '/providers/game_data.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

class ScheduleUploadScreen extends StatefulWidget {
  static const routeName = "/schedule-upload-screen";

  const ScheduleUploadScreen({super.key});

  @override
  State<ScheduleUploadScreen> createState() => _ScheduleUploadScreenState();
}

class _ScheduleUploadScreenState extends State<ScheduleUploadScreen> {
  final endColumn = 17;
  final endRow = 57;
  final placeColumn = 2;
  final timeRow = 9;
  final originalExcelPath = 'assets/documents/Book1.xlsx';
  final List<String> sheetNames = ["Sheet1"];

  List table = [];
  List tableMap = [];
  late List<Sheet> sheets;
  bool _isLoading = true;

  Future loadExcel() async {
    List<Sheet> results = [];

    ByteData data = await rootBundle.load(originalExcelPath);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var sheetName in excel.tables.keys) {
      if (sheetNames.contains(sheetName)) {
        if (excel.tables[sheetName] != null) {
          results.add(excel.tables[sheetName]!);
        }
      }
    }
    sheets = results;
    print(sheets);
    setState(() {
      _isLoading = false;
    });
  }

  Map<String, String> readGames(rowNum, colNum, sheet, date) {
    String id = sheet.rows[rowNum + 3][colNum].value;
    String team1 = sheet.rows[rowNum + 1][colNum].value;
    String team2 = sheet.rows[rowNum + 2][colNum].value;
    String time = sheet.rows[timeRow][colNum].value;
    String place = sheet.rows[rowNum][placeColumn].value;

    //sportの判定
    String sport = SportUtilities.sport(id.split('-')[0]);

    List<String> hourAndMin = time.split(":");
    id.toLowerCase();
    Map<String, String> data = {
      'id': id,
      'team1': team1,
      'team2': team2,
      'date': date,
      'hour': hourAndMin[0],
      'minute': hourAndMin[1],
      'place': place,
      'sport': sport
    };

    return data;
  }

  Future uploadData(table, context) async {
    for (Map<String, String> gameData in table) {
      var team = {'0': gameData['team1'], '1': gameData['team2']};
      var startTime = {
        'date': gameData['date'],
        'hour': gameData['hour'],
        'minute': gameData['minute']
      };
      var rumutaiStaff = 'スタッフ';
      var referees = {'0': '', '1': '', '2': ''};
      var extraTime = '';
      var gameStatus = 'before';
      var score = ['', ''];
      var scoreDetail = {
        '0': ['', ''],
        '1': ['', ''],
        '2': ['', '']
      };

      Map<String, Object> newData = {
        'gameId': table['id'],
        'team': team,
        'place': table['place'],
        'startTime': startTime,
        'referees': referees,
        'rumutaiStaff': rumutaiStaff,
        'score': score,
        'scoreDetail': scoreDetail,
        'extraTime': extraTime,
        'gameStatus': gameStatus
      };

      final gameDataProvider = Provider.of<GameData>(context, listen: false);
      gameDataProvider.updateData(
          doc: table['id'], newData: newData, teams: team);
    }
  }

  Widget _tablePreview(sheets) {
    for (int date = 1; date <= 2; date++) {
      for (int col = placeColumn + 1; col <= endColumn; col++) {
        for (int row = timeRow + 1; row <= endRow; col++) {
          if (row ~/ 4 == 0) {
            table.add(
                readGames(row, col, sheets[date - 1], date).values.toList());
            tableMap.add(readGames(row, col, sheets[date - 1], date));
          }
        }
      }
    }

    return Table(
      children: table.map((row) {
        return TableRow(
          children: row.map((cell) {
            return Text(cell);
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadExcel();
    return Scaffold(
      appBar: AppBar(
        title: const Text("日程表アップロード"),
      ),
      body: Column(
        children: [
          _isLoading
              ? const SizedBox(child: CircularProgressIndicator())
              : _tablePreview(sheets),
          ElevatedButton(
              onPressed: () {
                uploadData(tableMap, context);
              },
              child: const Text("アップロード"))
        ],
      ),
    );
  }
}
