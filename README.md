# Very Good Coffee

[![License: MIT][license_badge]][license_link]

Created by Mark Winters on the Very Good Core using the [Very Good CLI][very_good_cli_link] 🤖

---

![alt text](https://github.com/ridemax/very_good_coffee/blob/main/assets/images/barista.png?raw=true)

## Welcome!

This app allows a user to do the following:

- Download images of coffee
- Store favorite images to local storage for later review

## Project Goals

In addition to filling the basic product requirements listed above, I also had learning goals which mostly focused around using the Very Good Core as a starter template for the app. I found this to be a very solid foundation to build from.

I also used this exercise as an opportunity to try out the [flex_color_scheme][flex_color_scheme_link] package by Mike Rydstrom. I found the "Espresso and crema" theme especially appropriate for this app :blush:

A big shout out goes to OpenAI's [DALL-E 2][dall_e_2_link] for creating the barista image shown above and used in the app.

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Very Good Coffee works on iOS and Android._

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:very_good_coffee/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```
### Product Roadmap

- The app allows the user to save favorite images to local storage for review later, but doesn't offer a way
to delete them currently. This is high priority for a future release :blush:

- While marking an image as a favorite works, the visual transition to the "Added to favorites!" message appearing is too sudden for my taste. I'd like to add a smoother animation transition between touching the "favorite" icon and this message replacing it.

- This was my first time using the Very Good Core testing conventions, and I had just scratched the surface of this before running out of time. Should I come to work for VGV I'd make it a Very High Priority to practice implementing tests according to these standards before starting work.

- The PhotoRepository class throws three possible exception types: Network connection, json parse, and write data exceptions. These are all mapped at the Cubit level to what I expect by far to be the most common case, the network connection exception. We should handle the other two better by offering the user a prompt to flush the cache in the event of the latter two exceptions.

- Even though it's no longer used, I left the Counter code from the app template in place for now. It still serves as a useful example for implementing tests, etc.

[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[flex_color_scheme_link]: https://pub.dev/packages/flex_color_scheme
[dall_e_2_link]: https://labs.openai.com/
