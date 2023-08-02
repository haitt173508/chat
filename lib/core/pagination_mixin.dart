import 'dart:developer' show log;

import 'package:flutter/foundation.dart';

import 'constants/app_constants.dart';

mixin PaginationMixin {
  int get defaultInitialPageNumber => 1;

  int get defaultLimit => AppConst.limitOfListDataLengthForEachRequest;

  int getTotalRecordsFromPage(int page, int limit) => page * limit;

  bool canLoadMore(int currentPage, int totalRecords) =>
      getTotalRecordsFromPage(currentPage, defaultLimit) < totalRecords - 1;

  int getStartIndexNumber(int pageNumber, int limit) =>
      ((pageNumber - 1) * limit).clamp(0, double.infinity) as int;

  String getStartIndex(int pageNumber, int limit) =>
      getStartIndexNumber(pageNumber, limit).toString();

  int getEndIndexNumberFromCurrentPage(int pageNumber, int limit) =>
      getStartIndexNumber(pageNumber, limit) + limit;

  String getEndIndexFromCurrentPage(int pageNumber, int limit) =>
      getEndIndexNumberFromCurrentPage(pageNumber, limit).toString();

  debugLog(String message, [String name = 'PaginationMixin']) {
    if (kDebugMode) log(message, name: name);
  }
}
