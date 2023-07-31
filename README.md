# flutter_clean_architecture
<img width="300" alt="image" src="https://github.com/YamamotoDesu/flutter_clean_architecture/assets/47273077/e47021d0-19ac-404b-b47d-6fadf1360ed5">

```

[lib]
    ├── [config]
        ├── [routes]
        └── [theme]
    ├── [core]
        ├── [error]
        ├── [resoures]
        ├── [network]
        ├── [usecases]
        └── [utils]
    ├── [fetures]
        └── [auth]
            ├── [data]
                ├── [data_sources]
                ├── [models]
                └── [repository]
            ├── [domain]
                ├── [entities]
                ├── [repository]
                └── [usecases]
            └── [presentation]
                ├── [bloc]
                └── [pages]
    └── main.dart
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
