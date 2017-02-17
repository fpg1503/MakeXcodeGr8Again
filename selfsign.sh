#!/usr/bin/env bash

if [ -z "$APP" ]; then
  APP="/Applications/XcodeGr8.app"
fi

running=$(ps -ef | grep "$APP/Contents/MacOS/Xcode" | wc -l)
if [ $running != 1 ]; then
  echo "Please quit the Xcode app first."
  exit 1
fi

KEYCHAIN=$(tr -d "\"" <<< `security default-keychain`)

delPem=false
if [ ! -f XcodeSigner.pem ]; then
  echo "Downloading XcodeSigner.pem..."
  curl -L https://raw.githubusercontent.com/alanhamlett/MakeXcodeGr8Again/master/XcodeSigner.pem -o XcodeSigner.pem
  delPem=true
fi
delP12=false
if [ ! -f XcodeSigner.p12 ]; then
  echo "Downloading XcodeSigner.p12..."
  curl -L https://raw.githubusercontent.com/alanhamlett/MakeXcodeGr8Again/master/XcodeSigner.p12 -o XcodeSigner.p12
  delP12=true
fi

echo "Importing self-signed cert to default keychain..."
security import ./XcodeSigner.pem -k "$KEYCHAIN"
security import ./XcodeSigner.p12 -k "$KEYCHAIN" -P xcodesigner

echo "Resigning $APP, this may take a while..."
sudo codesign -f -s XcodeSigner $APP

echo "Installing Alcatraz..."
curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/deploy/Scripts/install.sh | sh

echo "Updating Alcatraz to use latest Xcode DVTPluginCompatibilityUUID..."
UUID=$(defaults read $APP/Contents/Info.plist DVTPlugInCompatibilityUUID)
find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add $UUID

if [ "$delPem" = true ]; then
  echo "Cleaning up XcodeSigner.pem..."
  rm XcodeSigner.pem
fi
if [ "$delP12" = true ]; then
  echo "Cleaning up XcodeSigner.p12..."
  rm XcodeSigner.p12
fi

echo "Finished. You may now use $APP with Alcatraz and other plugins."
exit 0
