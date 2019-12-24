# Dart LSIF indexer

Visit https://lsif.dev/ to learn about LSIF.

## Installation

Required tools:

- TODO

**macOS**

- Get the Dart SDK

```
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:`pwd`/depot_tools # add this to your ~/.bashrc or equivalent
mkdir dart-sdk
cd dart-sdk
fetch dart
```

- Make sure you have `xcode` installed (get it on the Apple app store).
- Build the Dart SDK

```
./tools/build.py --mode release --arch x64 create_sdk
```

- Add the Dart SDK binaries to your path

```
export PATH="$HOME/dart-sdk/sdk/sdk/bin:$PATH"
```

- Build `lsif-dart`

```
git clone https://github.com/sourcegraph/lsif-dart.git
pub get
make
```

**Ubuntu 18.04**

```
TODO
```

## Generating an LSIF dump

TODO

## Development

TODO
