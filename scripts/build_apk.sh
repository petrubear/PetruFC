#!/bin/sh
# Compila el APK release y lo copia como PetruFC.<version>.apk en build/
set -e
cd "$(dirname "$0")/.."
VERSION=$(sed -n 's/^version: \([0-9.]*\).*/\1/p' pubspec.yaml)
VERSION=${VERSION%.0}
FULL=$(sed -n 's/^version: \(.*\)/\1/p' pubspec.yaml)
printf "// Lo regenera scripts/build_apk.sh desde pubspec.yaml.\nconst appVersion = '%s';\n" "$FULL" > lib/core/app_version.dart
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "build/PetruFC.$VERSION.apk"
echo "APK: build/PetruFC.$VERSION.apk"
