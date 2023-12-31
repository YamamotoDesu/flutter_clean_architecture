import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/constants/constants.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/data/data_soures/local/app_database.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/entities/article.dart';

import 'package:flutter_clean_architecture/fetures/daily_news/domain/repository/article_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../data_soures/remotes/news_api_service.dart';
import '../models/article.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  ArticleRepositoryImpl(this._newsApiService, this._appDatabse);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(
        DioException(
          error: httpResponse.response.statusCode,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ),
      );
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  final AppDatabse _appDatabse;


  @override
  Future<List<ArticleModel>> getSavedArticles() {
    return _appDatabse.articleDao.getArticles();
  }

  @override
  Future<void> deleteArticle(ArticleEntity article) {
    return _appDatabse.articleDao.deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _appDatabse.articleDao.insertArticle(ArticleModel.fromEntity(article));
  }
}
