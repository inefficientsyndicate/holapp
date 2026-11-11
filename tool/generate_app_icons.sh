#!/usr/bin/env bash
# Regenerates every platform's app icon from assets/icon/hol_wordmark.svg.
# Requires ImageMagick 7 (`brew install imagemagick`). Run from anywhere.
set -euo pipefail
cd "$(dirname "$0")/.."

BACKGROUND='#0B1220' # Keep in sync with ic_launcher_background and web/manifest.json.
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

magick -background none -density 288 assets/icon/hol_wordmark.svg \
  -resize 2048x2048 "$TMP/wordmark.png"

# tile <percent> <out>: the wordmark, scaled and centered, on a transparent 2048 canvas.
tile() {
  magick -size 2048x2048 xc:none \( "$TMP/wordmark.png" -resize "$1%" \) \
    -gravity center -composite "$2"
}

# on_background <in> <out>: flattens onto the opaque background color.
on_background() {
  magick "$1" -background "$BACKGROUND" -alpha remove -alpha off "$2"
}

# export_png <in> <size> <out>
export_png() {
  magick "$1" -filter Lanczos -resize "$2x$2" -depth 8 -strip "PNG32:$3"
}

# export_opaque <in> <size> <out>: for targets that must not have an alpha channel.
export_opaque() {
  magick "$1" -filter Lanczos -resize "$2x$2" -depth 8 -strip -alpha off "PNG24:$3"
}

tile 100 "$TMP/full_glyphs.png"
on_background "$TMP/full_glyphs.png" "$TMP/full.png"

# Favicon: as large as it fits, because it is shown at 16px.
tile 112 "$TMP/favicon_glyphs.png"
on_background "$TMP/favicon_glyphs.png" "$TMP/favicon.png"

# Android adaptive safe zone: a 66/108 circle. Wordmark diagonal 982/1024 -> 62%.
tile 62 "$TMP/adaptive.png"

# Web maskable safe zone: a circle of 80% of the width -> 82%.
tile 82 "$TMP/maskable_glyphs.png"
on_background "$TMP/maskable_glyphs.png" "$TMP/maskable.png"

# Rounded tile with Apple's macOS margins (824/1024); also the Android pre-API-26 icon.
tile 80 "$TMP/rounded_glyphs.png"
magick -size 2048x2048 xc:none -fill "$BACKGROUND" \
  -draw 'roundrectangle 200,200 1847,1847 370,370' "$TMP/rounded_glyphs.png" \
  -composite "$TMP/rounded.png"

# iOS and macOS: every size the asset catalogs already declare.
for f in ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png; do
  export_opaque "$TMP/full.png" "$(magick identify -format %w "$f")" "$f"
done
for f in macos/Runner/Assets.xcassets/AppIcon.appiconset/*.png; do
  export_png "$TMP/rounded.png" "$(magick identify -format %w "$f")" "$f"
done

# Android: legacy icon plus adaptive foreground (108dp at each density).
RES=android/app/src/main/res
for pair in mdpi:48:108 hdpi:72:162 xhdpi:96:216 xxhdpi:144:324 xxxhdpi:192:432; do
  IFS=: read -r density legacy foreground <<<"$pair"
  export_png "$TMP/rounded.png" "$legacy" "$RES/mipmap-$density/ic_launcher.png"
  export_png "$TMP/adaptive.png" "$foreground" "$RES/mipmap-$density/ic_launcher_foreground.png"
done

# Web.
export_opaque "$TMP/favicon.png" 32 web/favicon.png
export_png "$TMP/full.png" 192 web/icons/Icon-192.png
export_png "$TMP/full.png" 512 web/icons/Icon-512.png
export_png "$TMP/maskable.png" 192 web/icons/Icon-maskable-192.png
export_png "$TMP/maskable.png" 512 web/icons/Icon-maskable-512.png

# Previews for the Settings page.
mkdir -p assets/icon/previews
export_opaque "$TMP/full.png" 192 assets/icon/previews/midnight.png

# alternate <name> <iOS set> <background> <glyphs> <dot>: an icon the user can
# switch to in Settings (iOS and Android only). Keep the backgrounds in sync
# with ic_launcher_background.xml.
alternate() {
  local name="$1" ios_set="$2" background="$3" glyphs="$4" dot="$5"
  local dir="$TMP/$name"
  mkdir -p "$dir"

  sed -e "s/#22C55E/@DOT@/g" -e "s/#FFFFFF/$glyphs/g" -e "s/@DOT@/$dot/g" \
    assets/icon/hol_wordmark.svg >"$dir/wordmark.svg"
  magick -background none -density 288 "$dir/wordmark.svg" \
    -resize 2048x2048 "$dir/wordmark.png"

  magick -size 2048x2048 xc:none \( "$dir/wordmark.png" -resize 62% \) \
    -gravity center -composite "$dir/adaptive.png"
  magick "$dir/wordmark.png" -background "$background" -alpha remove -alpha off "$dir/full.png"
  magick -size 2048x2048 xc:none -fill "$background" \
    -draw 'roundrectangle 200,200 1847,1847 370,370' \
    \( "$dir/wordmark.png" -resize 80% \) -gravity center -composite "$dir/rounded.png"

  local set="ios/Runner/Assets.xcassets/$ios_set.appiconset"
  mkdir -p "$set"
  export_opaque "$dir/full.png" 1024 "$set/Icon-1024.png"
  cat >"$set/Contents.json" <<'JSON'
{
  "images" : [
    {
      "filename" : "Icon-1024.png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
JSON

  local pair density legacy foreground
  for pair in mdpi:48:108 hdpi:72:162 xhdpi:96:216 xxhdpi:144:324 xxxhdpi:192:432; do
    IFS=: read -r density legacy foreground <<<"$pair"
    export_png "$dir/rounded.png" "$legacy" "$RES/mipmap-$density/ic_launcher_$name.png"
    export_png "$dir/adaptive.png" "$foreground" "$RES/mipmap-$density/ic_launcher_${name}_foreground.png"
  done
  cat >"$RES/mipmap-anydpi-v26/ic_launcher_$name.xml" <<XML
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_${name}_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_${name}_foreground"/>
    <monochrome android:drawable="@mipmap/ic_launcher_${name}_foreground"/>
</adaptive-icon>
XML

  export_opaque "$dir/full.png" 192 "assets/icon/previews/$name.png"
}

alternate light AppIconLight '#FFFFFF' '#0B1220' '#22C55E'
alternate green AppIconGreen '#16A34A' '#FFFFFF' '#0B1220'
