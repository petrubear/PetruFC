#!/bin/sh
# Compila el APK release y lo copia como PetruFC.<version>.apk en build/
set -e
cd "$(dirname "$0")/.."
VERSION=$(sed -n 's/^version: \([0-9.]*\).*/\1/p' pubspec.yaml)
VERSION=${VERSION%.0}
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "build/PetruFC.$VERSION.apk"
echo "APK: build/PetruFC.$VERSION.apk"
