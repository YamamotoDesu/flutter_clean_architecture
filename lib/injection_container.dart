
import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/data/data_soures/remotes/news_api_service.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/data/repository/article_repository_impl.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/repository/article_repository.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/usercases/get_article.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/bloc/article/remote/remote_article_bloc.dart';
import 'package:get_it/get_it.dart';

final s1 = GetIt.instance;

Future<void> initialaizeDependencies() async {

  // Dio
  s1.registerSingleton<Dio>(Dio());
  
  // Dependencies
  s1.registerSingleton<NewsApiService>(NewsApiService(s1()));

  s1.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(s1())
  );

  // UseCases
  s1.registerSingleton<GetArticleUseCase>(GetArticleUseCase(s1()));

  // Blocs
  s1.registerFactory<RemoteArticlesBloc>(
    ()=> RemoteArticlesBloc(s1())
  );
}