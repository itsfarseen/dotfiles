function assume-role
  set --erase AWS_SECRET_ACCESS_KEY
set --erase AWS_SESSION_TOKEN
set --erase AWS_SECURITY_TOKEN
set --erase ASSUMED_ROLE
eval (command assume-role -duration=12h $argv)

end
