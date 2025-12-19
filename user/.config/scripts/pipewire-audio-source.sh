#!/bin/bash

wpctl status | node -e '
process.stdin.on("data", (data) => {
  const str = data.toString();
  console.log(
    str
      .substring(str.indexOf("Sinks") + 6, str.indexOf("Sources") - 9)
      .trim()
      .split("\n")
      .map((s) => s.trim().substring(1).trim())
      .map((s) =>
        s.startsWith("*") ? s.substring(1).trim().split(" ").toSpliced(1, 0, "*").join(" ") : s,
      ).join("\n")
  );
});
' | fuzzel -d --log-level none --width 80 | awk '{print $1}' | head -c -2 | xargs wpctl set-default
