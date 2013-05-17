# Ruby Switch

Ruby Switch allows you to easily switch your Ruby Version and Gem Home based on your currently active git repository.

It makes use of rbenv, which can be found here:
[https://github.com/sstephenson/rbenv](https://github.com/sstephenson/rbenv)

It also assumes you are using git to manage your projects.

### Setting up
You will need to edit your `bashrc` to enable this to work. An example from my `bashrc` is below. This sets your prompt to show the current branch if you are in a git repository, and colour codes it based on the repository status.

It also looks for a script relating to the repository which it will then execute to setup the specified Ruby environment. If no such script can be found it will ensure your settings are restored to their defaults.

You will also need to store your original system `PATH` and `GEM_HOME` so that they can be reverted when changing Gem Home. The scripts expect to find variables named `DEFAULT_PATH` and `DEFAULT_GEM_HOME` to allow this to happen. This is done after the function to setup the command prompt.

Note: please remove any other `PS1=` lines if you use the below.

	set_bash_prompt ()
	{
		# setup git status for bash prompt
		git_status="$(git status 2> /dev/null)"

		if [[ ${git_status} =~ "working directory clean" ]]; then
			state="\001\e[0;32m\002" # Green
		elif [[ ${git_status} =~ "Changes to be committed" ]]; then
			state="\001\e[1;33m\002" # Yellow
		else
			state="\001\e[0;31m\002" # Red
		fi

		TITLEBAR='\[\e]0;\u@\h - \w\a\]'
		PS1="${TITLEBAR}[\u@\h \W${state}\$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/ [\1]/')${RESET}]\$ "

		unset git_status

		# Setup ruby environment if required
		project_name="$(git remote -v 2> /dev/null | head -n1 | awk '{print $2}' | sed 's/.*\///;s/.*\://;s/\.git//')"

		if [[ "$last_project_name" != "$project_name" ]]; then
		  last_project_name=$project_name
		  if [[ "${#project_name}" -gt 0 ]]; then
		    if [ -e $HOME/.ruby_projects/$project_name.sh ]; then
		      source $HOME/.ruby_projects/$project_name.sh
		    else
		      source $HOME/.ruby_projects/reset.sh
		    fi
		  else
		    source $HOME/.ruby_projects/reset.sh
		  fi
		fi
	}

	PROMPT_COMMAND=set_bash_prompt

	PATH=$PATH:$HOME/.rbenv/bin
	GEM_HOME=/path/to/default/gems

	eval "$(rbenv init -)"

	# Save default Path to enable clean Ruby switching
	DEFAULT_PATH=$PATH
	# Save default Gem Home to enable clean Ruby switching
	DEFAULT_GEM_HOME=$GEM_HOME
	# Now add default Gem Home to Path
	PATH=$DEFAULT_PATH:$GEM_HOME/bin

	export PATH
	export GEM_HOME
	export DEFAULT_PATH
	export DEFAULT_GEM_HOME
  # Default ruby build numbers
  export RUBY18="1.8.7-p370-gcc4.6"
  export RUBY19="1.9.3-p392"
  export RUBY20="2.0.0-p195"


Next, you will need to create the relevant directory to hold the switching scripts. Assuming you are within this repository, run the following command:

	$ cp -R sample_scripts ~/.ruby_projects

This will create a directory called `.ruby_projects` within your home directory. Inside here will be two files: `reset.sh` and `sample.sh`.

### Usage

This works based on the git project name. To find this out, navigate to a git project in the terminal, and once inside the main directory execute the following:

	$ git remote -v 2> /dev/null | head -n1 | awk '{print $2}' | sed 's/.*\///;s/.*\://;s/\.git//'

In order to make this easier, you can alias this in`.bashrc` or `.bash_profile` like so (note the escape on the $):

	alias repo_name="git remote -v 2> /dev/null | head -n1 | awk '{print \$2}' | sed 's/.*\///;s/.*\://;s/\.git//'"

This will return the string we will use to identify this project. Based on this, we can then add a script to the `~/.ruby_projects` folder to execute commands that switch the Ruby Version and Gem Home as required. Looking at the provided `sample.sh` script should make it clear how to achieve this. Simply copy it to a new file, and base the name on what is returned by the above command.

The other file in this folder is named `reset.sh`. The values set in here should reflect your preferred default values. This script is executed when you leave a git repository to return your setting to normal.

#### License

This is licensed under GNU GPL version 3: [http://www.gnu.org/licenses/gpl.html](http://www.gnu.org/licenses/gpl.html). See COPYING for more information.
