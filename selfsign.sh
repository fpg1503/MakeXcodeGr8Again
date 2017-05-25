#!/usr/bin/env bash

set -euo pipefail

PLUGINS_DIR="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
XCODE_VERSION="$(xcrun xcodebuild -version | head -n1 | awk '{ print $2 }')"
PLIST_PLUGINS_KEY="DVTPlugInManagerNonApplePlugIns-Xcode-${XCODE_VERSION}"
APP="/Applications/Xcode.app"

args="$@"

contains() {
  string="$1"
  if [[ -z ${2+x} ]]; then
    echo "";
  else
    substring="$2"
    if printf %s\\n "${string}" | grep -qF "${substring}"; then
      echo "1";
    else
      echo "";
    fi
  fi
}

if [[ $(contains "$args" "beta") ]]; then
  APP="/Applications/Xcode-beta.app"
fi

running=$(pgrep Xcode || true)
if [ "$running" != "" ]; then
  echo "Please quit Xcode then try running this script again."
  exit 1
fi

if [[ $(contains "$args" "copy") ]]; then
  echo "Copying Xcode.app to XcodeWithPlugins.app..."
  sudo cp -Rp "/Applications/Xcode.app" "/Applications/XcodeWithPlugins.app"
  APP="/Applications/XcodeWithPlugins.app"
fi

echo "Installing Alcatraz..."
curl -fsSL https://raw.github.com/alcatraz/Alcatraz/master/Scripts/install.sh | sh

echo "Make sure plugins have the latest Xcode compatibility UUIDs..."
UUIDS=$(defaults read $APP/Contents/Info.plist DVTPlugInCompatibilityUUID)
find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add $UUIDS

# Install a self-signing cert to enable plugins in Xcode 8
delPem=false
if [ ! -f XcodeSigner.pem ]; then
  echo "Downloading self-signed cert public key..."
  curl -L https://raw.githubusercontent.com/fpg1503/MakeXcodeGr8Again/master/XcodeSigner.pem -o XcodeSigner.pem
  delPem=true
fi
delP12=false
if [ ! -f XcodeSigner.p12 ]; then
  echo "Downloading self-signed cert private key..."
  curl -L https://raw.githubusercontent.com/fpg1503/MakeXcodeGr8Again/master/XcodeSigner.p12 -o XcodeSigner.p12
  delP12=true
fi

echo "Importing self-signed cert to default keychain, select Allow when prompted..."
KEYCHAIN=$(tr -d "\"" <<< `security default-keychain`)
security import ./XcodeSigner.pem -k "$KEYCHAIN" || true
security import ./XcodeSigner.p12 -k "$KEYCHAIN" -P xcodesigner || true

echo "Resigning $APP, this may take a while..."
sudo codesign -f -s XcodeSigner $APP

if [ "$delPem" = true ]; then
  echo "Cleaning up public key..."
  rm XcodeSigner.pem
fi
if [ "$delP12" = true ]; then
  echo "Cleaning up private key..."
  rm XcodeSigner.p12
fi

echo "Finished installing Alcatraz. Launching Xcode..."
open "$APP"

exit 0
