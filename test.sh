#!/bin/sh

# shellcheck disable=SC2039
read -r -d '' body <<- EOM
{
  "EventType": "StreamStarted",
  "EventTimestamp": "2023-10-19T00:00:00.0000000+08:00",
  "EventId": "c4bfb117-0b7e-4cf1-af72-a47e451bcc91",
  "EventData": {
    "RoomId": 1,
    "ShortId": 0,
    "Name": "哔哩哔哩直播",
    "Title": "轮播中 轮播中 轮播中",
    "AreaNameParent": "虚拟主播",
    "AreaNameChild": "虚拟Singer",
    "Recording": true,
    "Streaming": true,
    "DanmakuConnected": true
  }
}
EOM

curl -v 127.0.0.1:2346 \
-H 'Content-Type: application/json' \
-H 'User-Agent: BililiveRecorder/2.10.0' \
--data-raw "$body"
