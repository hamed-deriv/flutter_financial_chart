import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_financial_chart/data/models/candle_model.dart';
import 'package:flutter_financial_chart/presentation/widgets/candle_chart/candle_chart_model.dart';

class CandleChartPainter extends CustomPainter {
  CandleChartPainter({
    this.timeSeries,
    Paint? wickPaint,
    Paint? gainPaint,
    Paint? lossPaint,
    double? wickWidth,
    double? candleWidth,
  })  : _wickPaint = wickPaint ?? Paint()
          ..color = Colors.grey,
        _gainPaint = gainPaint ?? Paint()
          ..color = Colors.green,
        _lossPaint = lossPaint ?? Paint()
          ..color = Colors.red,
        _wickWidth = wickWidth ?? 2,
        _candleWidth = candleWidth ?? 4;

  final List<CandleModel>? timeSeries;
  final Paint _wickPaint;
  final Paint _gainPaint;
  final Paint _lossPaint;
  final double _wickWidth;
  final double _candleWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (timeSeries == null) {
      return;
    }

    final List<CandleChartModel> candles = _generateCandles(size);

    for (final CandleChartModel candle in candles) {
      canvas.drawRect(
        Rect.fromLTRB(
          candle.centerX - (_wickWidth / 2),
          size.height - candle.wickHighY,
          candle.centerX + (_wickWidth / 2),
          size.height - candle.wickLowY,
        ),
        _wickPaint,
      );

      canvas.drawRect(
        Rect.fromLTRB(
            candle.centerX - (_candleWidth / 2),
            size.height - candle.candleHighY,
            candle.centerX + (_candleWidth / 2),
            size.height - candle.candleLowY),
        candle.candlePaint,
      );
    }
  }

  List<CandleChartModel> _generateCandles(Size size) {
    final double pixelPerWidth = size.width / (timeSeries!.length + 1);
    final double maxHigh =
        timeSeries!.map((item) => item.high).reduce(math.max);
    final double minLow = timeSeries!.map((item) => item.low).reduce(math.min);
    final double pixelPerHigh = size.height / (maxHigh - minLow);

    List<CandleChartModel> candles = [];

    for (int i = 0; i < timeSeries!.length; i++) {
      final CandleModel currentElement = timeSeries![i];
      final bool isGain = currentElement.open < currentElement.close;

      candles.add(
        CandleChartModel(
          centerX: (i + 1) * pixelPerWidth,
          wickHighY: (currentElement.high - minLow) * pixelPerHigh,
          wickLowY: (currentElement.low - minLow) * pixelPerHigh,
          candleHighY: (currentElement.open - minLow) * pixelPerHigh,
          candleLowY: (currentElement.close - minLow) * pixelPerHigh,
          candlePaint: isGain ? _gainPaint : _lossPaint,
        ),
      );
    }

    return candles;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      this != oldDelegate;
}
