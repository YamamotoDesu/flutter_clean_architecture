
import 'package:flutter_clean_architecture/fetures/daily_news/data/models/article.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/entities/article.dart';

import '../../../../core/resources/data_state.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  // Database metholds 
  Future<List<ArticleModel>> getSavedArticles();

  Future<void> saveArticle(ArticleEntity article);

  Future<void> deleteArticle(ArticleEntity article);
}