#!/bin/sh

set -euo pipefail

sudo dnf install g++ npm python make gcc git rpm-build libxcrypt-compat patch ruby-devel
gem install fpm
dnf clean all
export PATH="$PATH:/home/$(whoami)/bin" USE_SYSTEM_FPM=true SIGNAL_ENV=production

[ -d Signal-Desktop ] || git clone https://github.com/signalapp/Signal-Desktop
cd Signal-Desktop
git pull
git checkout "v$1"
sed -i 's/"deb"$/"rpm"/' package.json

npm install
npm run clean-transpile
npm run generate
npm run prepare-beta-build
npm run build-linux

cd ..
sudo dnf install "./Signal-Desktop/release/signal-desktop-$1.aarch64.rpm"
rm -rf Signal-Desktop
