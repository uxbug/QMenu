on openApp(command)
    tell application "Finder"
        activate
        do shell script command
    end tell
end openApp