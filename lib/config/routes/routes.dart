import 'package:flutter/material.dart';

import '../../fetures/daily_news/domain/entities/article.dart';
import '../../fetures/daily_news/presentaion/pages/article_detail/article_detail.dart';
import '../../fetures/daily_news/presentaion/pages/home/daily_news.dart';
import '../../fetures/daily_news/presentaion/pages/saved_article/saved_article.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const DailyNews());

      case '/ArticleDetails':
        return _materialRoute(ArticleDetailsView(article: settings.arguments as ArticleEntity));

      case '/SavedArticles':
        return _materialRoute(const SavedArticles());
        
      default:
        return _materialRoute(const DailyNews());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}