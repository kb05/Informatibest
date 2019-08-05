# name: beloglazov

# This function return if any change exist in the git project
function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end


# Define some colors
set -g cyan (set_color -o cyan)
set -g yellow (set_color -o yellow)
set -g green (set_color green)
set -g red (set_color -o red --bold)
set -g brightred (set_color -o red)
set -g blue (set_color -o blue)
set -g normal (set_color normal)
set -g bold_blue (set_color 85dde0 --bold)
set -g bold_cold_blue (set_color 6191b8 --bold)
set -g bold_white (set_color FFFFFF --bold)
set -g bold_green (set_color 56bc28 --bold)
set -g bold_red (set_color -o red --bold)
set -g bold_yellow (set_color -o yellow --bold)
set -g bold_ligh_green (set_color -o green --bold)


# Define the colours of the characters
set -g pwdColor $bold_green
set -g timeColor $bold_white
set -g gitMasterBranchColor $bold_yellow
set -g gitNormalBranchColor $bold_white
set -g gitDirtyColor $bold_red
set -g gitCleanColor $bold_green
set -g errorColor $red
set -g rootUserColor $bold_red
set -g UserColor $bold_blue

#define pwd prefix
set pwdPrefix '...'
set pwdLimit 30

#The prompt function
function fish_prompt

  #Save the last status (just in case some command in the function changes it)
  set -l _last_status $status


  #Set the colors of the brackets based on the error code
  if [ $_last_status != 0 ]
        set  baseSBracketColor $errorColor 
        set  promptColor $errorColor
        set  errorInfo ' ' $errorColor  \[  $_last_status \] 
  else 
        set  baseSBracketColor $bold_cold_blue 
        set  promptColor $normal
        set  errorInfo ''
  end

  set  baseRBracketColor $baseSBracketColor 

  set -l openSBracket $baseSBracketColor \[ $normal
  set -l closeSBracket $baseSBracketColor \] $normal
  set -l openRBracket $baseRBracketColor \( $normal
  set -l closeRBracket $baseRBracketColor \) $normal


  # Set a different color to the name and the hostname if the user is the root
  if [ 'root' = (whoami) ]
      set userName $rootUserColor $USER @ (hostname)
  else
      set userName $UserColor $USER @ (hostname)
  end
 
  # Get the current time
  set _time (date "+%H:%M");
  set time $timeColor $_time;

  # Get the current path
  set _pwd (pwd)

  # If the pwd string is too long will be shortened to the $pwdLimit (and add the $pwdPrefix before)
  if [ (echo -n $_pwd | wc -m) -ge $pwdLimit ]
  	 set _pwd $pwdPrefix (echo $_pwd| tail -c $pwdLimit| grep -o '\/.*');
  end


  set pwd $pwdColor $_pwd

  #Get the current branch name
  set git_branch_name (git_branch_name)


  # This conditions set the git_info var, a string with the git information formatted
  if [ $git_branch_name ]

    # If the git branch is master appear indicated with another color
    if test $git_branch_name = "master"
      set git_branch $gitMasterBranchColor $git_branch_name
    else
      set git_branch $gitNormalBranchColor $git_branch_name
    end

   # Put a ✗ or ✔ depending on the error
   if [ (_is_git_dirty) ]
      set  git_status $gitDirtyColor ' ✗' 
    else
      set  git_status $gitCleanColor ' ✔'
    end


   #Set the git_info with the information formatted
   set git_info $baseRBracketColor $openRBracket $git_branch $git_status $closeRBracket 
  end


  #Print the custom prompt

  echo -n -s \
  # Write the initial [
  $openSBracket \
  #write the hour (example: 13:00)
  ' ' $time  ' ' $closeSBracket ' ' \
  #Write the user and directory (example : luis@ubuntu:/home/luis)
  $openSBracket ' ' $userName : $pwd ' ' \
  #write the git info (Example: master ✔)
  $git_info \
  #write the final ]
  $closeSBracket \
  #write the error info ( [...] 127   *The error code)
  $errorInfo \f\r \
  #write the initial $
  $promptColor ' ' \$ ' '

end
