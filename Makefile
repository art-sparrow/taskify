icons:
		dart run flutter_launcher_icons:main

splash:
		dart run flutter_native_splash:create

gen:
		dart run build_runner build --delete-conflicting-outputs

fmt:
		dart fix --apply && dart format lib test 

apk:
		flutter build apk --target=lib/main_production.dart -vv

dev-apk:
		flutter build apk --target=lib/main_development.dart -vv

aab:
		flutter build appbundle

base64:
		cat path/to/keystore | openssl base64 | tr -d '\n' | pbcopy

ipa:
		flutter build ipa --target=lib/main_production.dart

sha1:
		keytool -list -v -keystore ~/.android/debug.keystore

rdr:
		flutter run --target=lib/main_development.dart --release

rpr:
		flutter run --target=lib/main_production.dart --release

pods:
		cd ios && pod install --repo-update --verbose && cd ..

.PHONY: git_push
git_push:
		dart fix --apply && dart format lib test 
		dart format --set-exit-if-changed lib test
		flutter analyze lib
		git add .
		git commit -m "Resolve linting errors"
		git push
		