#!/usr/bin/env bash
set -e

EXPORT_TO="clipboard"

while [[ "$#" -gt 0 ]]
do case $1 in
  --export) EXPORT_TO="$2"
  shift;;
  *) echo "Unknown parameter: $1"
  exit 1;;
esac
shift
done

NSOBJECT_COUNT=$(grep -or --include \*.swift NSObject ./ | wc -l)
NSOBJECTCOMPAT_COUNT=$(grep -or --include \*.swift NSObjectCompat ./ | wc -l)
OBJC_COUNT=$(grep -or --include \*.swift @objc ./ | wc -l)
OBJCMEMBERS_COUNT=$(grep -or --include \*.swift @objcMembers ./ | wc -l)

NSOBJECTCOMPAT_COUNT=$(($NSOBJECTCOMPAT_COUNT))
NSOBJECT_COUNT=$(($NSOBJECT_COUNT-$NSOBJECTCOMPAT_COUNT))
OBJCMEMBERS_COUNT=$(($OBJCMEMBERS_COUNT))
OBJC_COUNT=$(($OBJC_COUNT-$OBJCMEMBERS_COUNT))

echo "NSObject:       $NSOBJECT_COUNT"
echo "NSObjectCompat: $NSOBJECTCOMPAT_COUNT"
echo "@objc:          $OBJC_COUNT"
echo "@objcMembers:   $OBJCMEMBERS_COUNT"

if [[ "$EXPORT_TO" == "clipboard" ]]; then
  echo -e "$NSOBJECT_COUNT\t$NSOBJECTCOMPAT_COUNT\t$OBJC_COUNT\t$OBJCMEMBERS_COUNT"| pbcopy
  echo "Copied to clipboard"
elif [[ "$EXPORT_TO" == "env" ]]; then
  export NSOBJECT_COUNT=1
  export NSOBJECTCOMPAT_COUNT
  export OBJC_COUNT
  export OBJCMEMBERS_COUNT
  echo "Exported to environment"
else
  echo "Unknown export type: $EXPORT_TO"
fi
