import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/bloc/article/remote/remote_article_bloc.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/bloc/article/remote/remote_article_event.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/pages/home/daily_news.dart';

import 'config/routes/routes.dart';
import 'config/theme/app_themes.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialaizeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteArticlesBloc>(
      create: (context) => sl()
        ..add(
          const GetArticles(),
        ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: theme(),
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        home: const DailyNews(),
      ),
    );
  }
}
