property export_type : "PNG"

on run argv
	if length of argv is 0 then
		return "Usage: graffle-to-png.applescript <source.graffle> <destination.png>  "
	end if

  set s_arg to item 1 of argv
  set d_arg to item 2 of argv

  set s_file to (POSIX file s_arg) as string
  set d_file to (POSIX file d_arg) as string

  tell application "OmniGraffle"
    activate
    open file s_file
    save front window as export_type in d_file
    close front window
  end tell
end run