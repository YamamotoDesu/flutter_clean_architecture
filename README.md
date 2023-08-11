# [flutter_clean_architecture](https://www.youtube.com/watch?v=7V_P6dovixg&list=WL&index=8)
<img width="300" alt="image" src="https://github.com/YamamotoDesu/flutter_clean_architecture/assets/47273077/e47021d0-19ac-404b-b47d-6fadf1360ed5">
<img width="300" alt="image" src="https://github.com/YamamotoDesu/flutter_clean_architecture/assets/47273077/35a3ef0d-34b9-4b97-ae64-7653162af08b">


```
- lib
  - config
    - routes
    - theme
  - core
    - constants
    - error
    - network
    - resources
    - usecases
    - utils
  - fetures
    - sample
      - data
        - data_sources
        - models
        - repository
      - domain
        - entities
        - repository
        - usecases
      - presentation
        - bloc
        - pages
  - injection_container.dart
  - main.dart
```

pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2

  #flutter bloc
  flutter_bloc: ^8.1.2

  #comparing dart objects
  equatable: ^2.0.5

  #service locator
  get_it: ^7.6.0

  #dateFormatter
  intl: ^0.18.1

  #Databse
  floor: ^1.4.2

  #hooks
  flutter_hooks: ^0.18.3

  #chached image
  cached_network_image: ^3.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^1.0.0
  retrofit_generator: ^3.0.1+1
  floor_generator: 1.2.0
  build_runner: 2.1.2

flutter:

  flutter_lints: ^2.0.0

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  fonts:
  - family: Muli
    fonts:
      - asset: assets/fonts/muli/Muli.ttf
      - asset: assets/fonts/muli/Muli-Bold.ttf
        weight: 700
      - asset: assets/fonts/muli/Muli-Light.ttf
        weight: 300
```

## Presentation Layer
```
- presentaion
        - bloc
          - article
            - remote
              - remote_article_bloc.dart
              - remote_article_event.dart
              - remote_article_state.dart
        - pages
          - home
            - daily_news.dart
        - widgets
          - article_tile.dart
```

lib/fetures/daily_news/presentaion/pages/home/daily_news.dart
```dart
  _buildBody() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (_, state) {
        if (state is RemoteArticlesLoading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        if (state is RemoteArticlesError) {
          return const Center(
            child: Icon(Icons.refresh),
          );
        }

        if (state is RemoteArticlesDone) {
          return ListView.builder(
            itemBuilder: (contex, index) {
              return ArticleWidget(article: state.articles![index]);
            },
            itemCount: state.articles!.length,
          );
        }
        return const SizedBox();
      },
    );
```

lib/fetures/daily_news/presentaion/bloc/article/remote/remote_article_state.dart
```dart
abstract class RemoteArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  final DioException? error;

  const RemoteArticlesState({this.articles, this.error});

  @override
  List<Object> get props => [articles!, error!];
}

class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

class RemoteArticlesDone extends RemoteArticlesState {
  const RemoteArticlesDone(List<ArticleEntity> articles) : super(articles: articles);
}

class RemoteArticlesError extends RemoteArticlesState {
  const RemoteArticlesError(DioException error) : super(error: error);
}
```

lib/fetures/daily_news/presentaion/bloc/article/remote/remote_article_event.dart
```dart
abstract class RemoteArticlesEvent {
  const RemoteArticlesEvent();
}

class GetArticles extends RemoteArticlesEvent {
  const GetArticles();
}
```

lib/fetures/daily_news/presentaion/bloc/article/remote/remote_article_bloc.dart
```dart

class RemoteArticlesBloc extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {

  final GetArticleUseCase _getArticleUseCase;

  RemoteArticlesBloc(this._getArticleUseCase) : super(const RemoteArticlesLoading()) {
    on <GetArticles> (onGetArticles);
  }

  void onGetArticles(GetArticles event, Emitter<RemoteArticlesState> emitter) async {
    final datastate = await _getArticleUseCase();

    if (datastate is DataSuccess && datastate.data!.isNotEmpty) {
      emit(
        RemoteArticlesDone(datastate.data!)
      );
    }

    if (datastate is DataFailed) {
      print(datastate.error!.message);
      emit(
        RemoteArticlesError(datastate.error!)
      );
    }
  }
}
```

## Domain Layer

```
      - domain
        - entities
          - article.dart
        - repository
          - article_repository.dart
        - usercases
          - get_article.dart
```

lib/fetures/daily_news/domain/entities/article.dart
```dart
import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final int? id;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  const ArticleEntity({
    this.id,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  @override
  List<Object?> get props {
    return [
      id,
      author,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content,
    ];
  }
}
```

lib/fetures/daily_news/domain/repository/article_repository.dart
```dart
abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();
}
```

lib/fetures/daily_news/domain/usercases/get_article.dart
```dart
class GetArticleUseCase implements UseCase<DataState<List<ArticleEntity>>, void> {
  final ArticleRepository _repository;

  GetArticleUseCase(this._repository);

  @override
  Future<DataState<List<ArticleEntity>>> call({void params}) {
    return  _repository.getNewsArticles();
  }
}
```

## Database Layer
### Dao Pattern
![image](https://github.com/YamamotoDesu/flutter_clean_architecture/assets/47273077/02b12276-4bee-4795-98e9-36d8e25682ec)

```
    - data
      - data_soures
        - local
          - DAO
            - article_dao.dart
            - app_database.dart
            - app_database.g.dart
```

lib/fetures/daily_news/data/data_soures/local/DAO/article_dao.dart
```dart
import 'package:floor/floor.dart';

import '../../../models/article.dart';

@dao
abstract class ArticleDao {

  @Insert()
  Future<void> insertArticle(ArticleModel article);

  @delete
  Future<void> deleteArticle(ArticleModel articleModel);

  @Query('SELECT * FROM article')
  Future<List<ArticleModel>> getArticles();
}
```

lib/fetures/daily_news/data/data_soures/local/app_database.dart
```dart

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../models/article.dart';
import 'DAO/article_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [ArticleModel])
abstract class AppDatabse extends FloorDatabase {
  ArticleDao get articleDao;
}
```

lib/injection_container.dart
```dart

final s1 = GetIt.instance;

Future<void> initialaizeDependencies() async {

  final database = await $FloorAppDatabse.databaseBuilder('app_database.db').build();
  s1.registerSingleton<AppDatabse>(database);

```

### Add UseCase
lib/fetures/daily_news/domain/usercases/get_saved_article.dart
```dart

import '../repository/article_repository.dart';

class GetSavedArticleUseCase implements UseCase<List<ArticleEntity>, void> {
  final ArticleRepository _repository;

  GetSavedArticleUseCase(this._repository);

  @override
  Future<List<ArticleEntity>> call({void params}) {
    return  _repository.getSavedArticles();
  }
}
```

lib/fetures/daily_news/domain/usercases/remove_article.dart
```dart
import '../repository/article_repository.dart';

class RemoveArticleUseCase implements UseCase<void, ArticleEntity> {
  final ArticleRepository _repository;

  RemoveArticleUseCase(this._repository);

  @override
  Future<void> call({ArticleEntity? params}) {
    return _repository.deleteArticle(params!);
  }
}

```

lib/fetures/daily_news/domain/usercases/save _article.dart
```dart
class SavedArticleUseCase implements UseCase<void, ArticleEntity> {
  final ArticleRepository _repository;

  SavedArticleUseCase(this._repository);

  @override
  Future<void> call({ArticleEntity? params}) {
    return _repository.saveArticle(params!);
  }
}

```

lib/injection_container.dart
```dart

  s1.registerSingleton<GetSavedArticleUseCase>(
    GetSavedArticleUseCase(s1())
  );

  s1.registerSingleton<SavedArticleUseCase>(
    SavedArticleUseCase(s1())
  );

  s1.registerSingleton<RemoveArticleUseCase>(
    RemoveArticleUseCase(s1())
  );

```


## Service Locator Pattern
![image](https://github.com/YamamotoDesu/flutter_clean_architecture/assets/47273077/c2a59961-bf54-457c-b29b-d76eef8eb0b1)

###  DI(get_it)
IF not using DI
```dart
Api api = Api(clinet: Client());

class Api {
  Client clinet;

  Api({this.client})
}

class HomeScreen extends StatelessWidget {
  Api api;

  HomeScreen({this.api})
}

HomeScreen(api: Api(clent: Clent());
```

---- 
If using DI
lib/injection_container.dart
```dart
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
```

main.dart
```dart

void main() async 
  await initialaizeDependencies();
  runApp(const MyApp());
}
```

<img width="875" alt="image" src="https://github.com/YamamotoDesu/flutter_clean_architecture/assets/47273077/6530c071-3eea-447d-8438-2b51cbbe93c5">

## [Model Testing | Part 3](https://www.youtube.com/watch?v=0MbGFiOUGGg)

### 🤡 prepare a dummy JSON and a helper class for reading


test/helpers/dummy_data/dummy_weather_response.json
```json
{
       "coord": {
              "lon": -74.006,
              "lat": 40.7143
       },
       "weather": [
              {
                     "id": 800,
                     "main": "Clear",
                     "description": "clear sky",
                     "icon": "01n"
              }
       ],
       "base": "stations",
       "main": {
              "temp": 292.87,
              "feels_like": 292.73,
              "temp_min": 290.47,
              "temp_max": 294.25,
              "pressure": 1012,
              "humidity": 70
       },
       "visibility": 10000,
       "wind": {
              "speed": 6.26,
              "deg": 319,
              "gust": 8.94
       },
       "clouds": {
              "all": 0
       },
       "dt": 1690708177,
       "sys": {
              "type": 2,
              "id": 2008101,
              "country": "JP",
              "sunrise": 1690710627,
              "sunset": 1690762457
       },
       "timezone": -14400,
       "id": 5128581,
       "name": "Tokyo",
       "cod": 200
}
```

test/helpers/json_reader.dart
```dart
import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return File('$dir/test/$name').readAsStringSync();
}

```

✅ 

test/data/models/weather_model_test.dart
```dart
import 'dart:convert';

import 'package:clean_architecture_testing/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/json_reader.dart';

void main() {
  const testWeatherModel = WeatherModel(
    cityName: 'Tokyo',
    main: 'Clear',
    description: 'clear sky',
    iconCode: '01n',
    temperature: 292.87,
    pressure: 1012,
    humidity: 70,
  );
  test(
    'should be a subclass of weather entity',
    () async {
      // assert
      expect(testWeatherModel, isA<WeatherModel>());
    },
  );

  test(
    'should return a valid model from json',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('helpers/dummy_data/dummy_weather_response.json'),
      );

      // act
      final result = WeatherModel.fromJson(jsonMap);

      // expect
      expect(result, testWeatherModel);
    },
  );

  test('should return a json map containing proper data', () async {
    // act
    final result = testWeatherModel.toJson();

    // assert
    final expectedJsonMap = {
      "weather": [
        {
          "main": "Clear",
          "description": "clear sky",
          "icon": "01n",
        }
      ],
      "main": {
        "temp": 292.87,
        "pressure": 1012,
        "humidity": 70,
      },
      "name": "Tokyo",
    };

    expect(result, expectedJsonMap);
  });
}
```

