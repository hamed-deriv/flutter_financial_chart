import 'package:flutter_financial_chart/data/models/time_series_model.dart';

abstract class BaseRepository {
  Future<TimeSeriesModel> fetchTimeSeries({
    required String symbol,
    required int interval,
  });
}
