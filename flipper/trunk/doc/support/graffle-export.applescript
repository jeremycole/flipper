on run argv
	if length of argv is 0 then
		return "Usage: graffle-export.applescript <file type> <source.graffle> <destination.png>  "
	end if

  set export_type to item 1 of argv
  set s_arg to item 2 of argv
  set d_arg to item 3 of argv

  set s_file to (POSIX file s_arg) as string
  set d_file to (POSIX file d_arg) as string

  tell application "OmniGraffle"
    open file s_file
    save front window as export_type in d_file
    close front window
  end tell
end run