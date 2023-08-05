// ignore_for_file: unused_import, null_check_always_fails, avoid_print

import 'dart:convert';

import 'package:covid_tracker/Models/world_stats_model.dart';
import 'package:covid_tracker/Services/Utilities/app_url.dart';
import 'package:http/http.dart' as http;

class StatsServices {
  Future<WorldStatsModel> fetchWorldStatsRecord() async {
    try {
      final response = await http.get(Uri.parse(AppUrl.worldStatsApi));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);

        return WorldStatsModel.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
    }
    return null!;
  }

  Future<List<dynamic>> countriesListApi() async {
    try {
      final response = await http.get(Uri.parse(AppUrl.countries));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      print(e.toString());
    }
    return null!;
  }
}
