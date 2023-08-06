
import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/data/data_soures/remotes/news_api_service.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/data/repository/article_repository_impl.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/repository/article_repository.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/usercases/get_article.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/usercases/get_saved_article.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/usercases/remove_article.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/usercases/save%20_article.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/bloc/article/remote/remote_article_bloc.dart';
import 'package:get_it/get_it.dart';

import 'fetures/daily_news/data/data_soures/local/app_database.dart';
import 'fetures/daily_news/presentaion/bloc/article/local/local_article_bloc.dart';

final sl = GetIt.instance;

Future<void> initialaizeDependencies() async {

  final database = await $FloorAppDatabse.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabse>(database);

  // Dio
  sl.registerSingleton<Dio>(Dio());
  
  // Dependencies
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl(), sl())
  );

  // UseCases
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));

  sl.registerSingleton<GetSavedArticleUseCase>(
    GetSavedArticleUseCase(sl())
  );

  sl.registerSingleton<SavedArticleUseCase>(
    SavedArticleUseCase(sl())
  );

  sl.registerSingleton<RemoveArticleUseCase>(
    RemoveArticleUseCase(sl())
  );

  // Blocs
  sl.registerFactory<RemoteArticlesBloc>(
    ()=> RemoteArticlesBloc(sl())
  );

  sl.registerFactory<LocalArticleBloc>(
    ()=> LocalArticleBloc(sl(), sl(), sl())
  );
}