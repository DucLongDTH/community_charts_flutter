// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Example of a numeric combo chart with two series rendered as bars, and a
/// third rendered as a line.
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';

class NumericComboLineBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  NumericComboLineBarChart(this.seriesList, {this.animate = false});

  /// Creates a [LineChart] with sample data and no transition.
  factory NumericComboLineBarChart.withSampleData() {
    return new NumericComboLineBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory NumericComboLineBarChart.withRandomData() {
    return new NumericComboLineBarChart(_createRandomData());
  }

  /// Create random data.
  static List<charts.Series<LinearSales, num>> _createRandomData() {
    final random = new Random();

    final desktopSalesData = List.generate(30, (index) {
      return LinearSales(index, random.nextInt(100));
    });

    final tableSalesData = List.generate(30, (index) {
      return LinearSales(index, desktopSalesData[index].sales);
    });

    final mobileSalesData = List.generate(30, (index) {
      return LinearSales(index, tableSalesData[index].sales * 2);
    });
    return [
      new charts.Series<LinearSales, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: desktopSalesData,
      )
        // Configure our custom bar renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customBar'),
      new charts.Series<LinearSales, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: tableSalesData,
      )
        // Configure our custom bar renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customBar'),
      new charts.Series<LinearSales, int>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: mobileSalesData),
    ];
  }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return new charts.NumericComboChart(seriesList,
        gradientConfig: ChartCanvasDecorationConfig(
          isShowGradient: true,
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.blue,
            ],
          ),
        ),
        animate: animate,
        behaviors: [
          charts.PanAndZoomBehavior(),
          charts.SlidingViewport(),
        ],
        // Configure the default renderer as a line renderer. This will be used
        // for any series that does not define a rendererIdKey.
        defaultRenderer: new charts.LineRendererConfig(
            strokeWidthPx: 4,
            lineBorderWidth: 5,
            lineBorderColor: charts.Color.fromHex(code: '#000000')),
        // Custom renderer configuration for the bar series.
        customSeriesRenderers: [
          new charts.BarRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customBar'),
          charts.PointRendererConfig(
            customRendererId: 'PointRendererConfig',
            radiusPx: 3.5,
            strokeWidthPx: 2.0,
            // symbolRenderer: charts.SymbolRenderer,

            pointRendererDecorators: [
              charts.PointLabelDecorator<num>(
                labelCallback: (domain) {
                  if (domain is LinearSales?) {
                    // final selected = selectedDomains.contains(domain);
                    return charts.PointLabelSpec(
                      label: domain?.sales.toString() ?? '',
                      selected: false,
                    );
                  }
                  return charts.PointLabelSpec(
                    label: '',
                    selected: false,
                  );
                },
              )
            ],
          ),
          charts.LineRendererConfig(
            customRendererId: 'renderId',
            areaOpacity: 0.1,
            dashPattern: null,
            includeArea: false,
            includeLine: true,
            includePoints: false,
            radiusPx: 3.5,
            roundEndCaps: false,
            strokeWidthPx: 2.0,
            lineBorderColor: null,
            lineBorderWidth: null,
            pointRendererDecorators: [
              charts.PointLabelDecorator<num>(
                labelCallback: (domain) {
                  if (domain is LinearSales?) {
                    // final selected = selectedDomains.contains(domain);
                    return charts.PointLabelSpec(
                      label: domain?.sales.toString() ?? '',
                      selected: false,
                    );
                  }
                  return charts.PointLabelSpec(
                    label: '',
                    selected: false,
                  );
                },
              )
            ],
          )
        ]);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final desktopSalesData = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    final tableSalesData = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    final mobileSalesData = [
      new LinearSales(0, 10),
      new LinearSales(1, 50),
      new LinearSales(2, 200),
      new LinearSales(3, 150),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: desktopSalesData,
      )
        // Configure our custom bar renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customBar'),
      new charts.Series<LinearSales, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: tableSalesData,
      )
        // Configure our custom bar renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customBar'),
      new charts.Series<LinearSales, int>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: mobileSalesData),
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
