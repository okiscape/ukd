function rfind --wraps='grep -RIn --color=auto' --description 'alias rfind=grep -RIn --color=auto'
  grep -RIn --color=auto $argv
        
end
