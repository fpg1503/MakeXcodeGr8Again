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
# security unlock-keychain "$KEYCHAIN"

echo "Downloading self-signed cert..."
if [ ! -f XcodeSigner.pem ]; then
  curl -L https://raw.githubusercontent.com/alanhamlett/MakeXcodeGr8Again/master/XcodeSigner.pem -o XcodeSigner.pem
fi
if [ ! -f XcodeSigner.p12 ]; then
  curl -L https://raw.githubusercontent.com/alanhamlett/MakeXcodeGr8Again/master/XcodeSigner.p12 -o XcodeSigner.p12
fi

echo "Importing self-signed cert to default keychain..."
security import ./XcodeSigner.pem -k "$KEYCHAIN"
security import ./XcodeSigner.p12 -k "$KEYCHAIN" -P xcodesigner
# security add-trusted-cert -k "$KEYCHAIN" ./XcodeSigner.pem

echo "Resigning $APP, this may take a while..."
sudo codesign -f -s XcodeSigner $APP

echo "Installing Alcatraz..."
curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/deploy/Scripts/install.sh | sh

echo "Updating Alcatraz to use latest Xcode DVTPluginCompatibilityUUID..."
UUID=$(defaults read $APP/Contents/Info.plist DVTPlugInCompatibilityUUID)
find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add $UUID

echo "Finished. You may now use Xcode with Alcatraz and other plugins."
exit 0
