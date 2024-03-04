import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics>  with SingleTickerProviderStateMixin{
  late List<charts.Series<Pollution, String>> _seriesData = [];
  late List<charts.Series<Sales, int>> _seriesLineData = [];

  _generateData() {
    var data1 = [
      new Pollution(1980, 'USA', 30),
      new Pollution(1980, 'India', 40),
      new Pollution(1980, 'Europe', 10),
    ];
    var data2 = [
      new Pollution(1985, 'USA', 100),
      new Pollution(1980, 'India', 150),
      new Pollution(1985, 'Europe', 80),
    ];
    var data3 = [
      new Pollution(1985, 'USA', 110),
      new Pollution(1980, 'India', 187),
      new Pollution(1985, 'Europe', 122),
    ];

    var linesalesdata = [
      new Sales(0, 45),
      new Sales(1, 56),
      new Sales(2, 55),
      new Sales(3, 60),
      new Sales(4, 61),
      new Sales(5, 70),
    ];
    var linesalesdata1 = [
      new Sales(0, 35),
      new Sales(1, 46),
      new Sales(2, 45),
      new Sales(3, 50),
      new Sales(4, 51),
      new Sales(5, 60),
    ];

    var linesalesdata2 = [
      new Sales(0, 20),
      new Sales(1, 24),
      new Sales(2, 25),
      new Sales(3, 40),
      new Sales(4, 45),
      new Sales(5, 60),
    ];

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2022',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2023',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2024',
        data: data3,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Air Pollution',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _seriesData = List<charts.Series<Pollution, String>>();
    // _seriesPieData = List<charts.Series<Task, String>>();
    // _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
  }
  late final _tabController = TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        //==========================  Tab bar ======================================

        appBar: AppBar(
           backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          title: Text('Sales Analytics'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(FontAwesomeIcons.solidChartBar,)),
              Tab(icon: Icon(FontAwesomeIcons.chartLine)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                        Expanded(
                        child: charts.BarChart(
                          _seriesData,
                          animate: true,
                          barGroupingType: charts.BarGroupingType.grouped,
                          //behaviors: [new charts.SeriesLegend()],
                          animationDuration: Duration(seconds: 5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Sales for the first 2 years',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                      Expanded(
                        child: charts.LineChart(
                            _seriesLineData,
                            defaultRenderer: new charts.LineRendererConfig(
                                includeArea: true, stacked: true),
                            animate: true,
                            animationDuration: Duration(seconds: 5),
                            behaviors: [
                              new charts.ChartTitle('Years',
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                              new charts.ChartTitle('Sales',
                                  behaviorPosition: charts.BehaviorPosition.start,
                                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                              new charts.ChartTitle('Departments',
                                behaviorPosition: charts.BehaviorPosition.end,
                                titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
                              )
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}