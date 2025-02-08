import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsDeviceConsumptionPieChart extends StatelessWidget {
  const StatsDeviceConsumptionPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: SfCircularChart(
            series: <CircularSeries>[
              PieSeries<Consumption, String>(
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                dataSource: const [
                  Consumption(day: 'First', usage: 20),
                  Consumption(day: 'Fan', usage: 22),
                  Consumption(day: 'Light', usage: 30),
                  Consumption(day: 'AC', usage: 36),
                  Consumption(day: 'Refrigerator', usage: 19),
                  Consumption(day: 'Washing Machine', usage: 25),
                  Consumption(day: 'Heater', usage: 20),
                  Consumption(day: 'Cleaner', usage: 33),
                  Consumption(day: 'TV', usage: 25),
                ],
                xValueMapper: (Consumption consumption, _) => consumption.day,
                yValueMapper: (Consumption consumption, _) =>
                consumption.usage,
                dataLabelMapper: (Consumption consumption, _) =>
                '${consumption.day}: ${consumption.usage} kWh',
                selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: const Color(0xFFFF5722),
                  selectedOpacity: 0.6,
                  unselectedOpacity: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Consumption {
  final String day;
  final double usage;

  const Consumption({required this.day, required this.usage});
}
