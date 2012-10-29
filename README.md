# Ruby Switch

Ruby Switch allows you to easily switch your Ruby Version and Gem Home based on
your currently active git repository.

### Setting up
You will need to edit your bashrc to enable this to work. Example below:

	set_bash_prompt ()
	{
		# Setup ruby environment if required
		project_name="$(git remote -v 2> /dev/null | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//')"

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

You will also need to store your original system PATH so that it can be reverted
when changing Gem Home. The scripts expect to find a variable named `DEFAULT_PATH`
to allow this to happen. This can be accomplished by adding the following lines to
your bash_profile:

	# Save default path to enable clean ruby switching
	DEFAULT_PATH=$PATH

Next, you will need to create the relevant directory to hold the switching scripts.
Assuming you are within this repository, run the following command:

	$ cp -R sample_scripts ~/.ruby_projects

This will create a directory called `.ruby_projects` within your home directory.
Inside here will be two files: `reset.sh` and `sample.sh`.

### Usage

This works based on the git project name. To find this out, navigate to a git
project in the terminal, and once inside the main directory execute the following:

	$ git remote -v 2> /dev/null | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//'

This will return the string we will use to identify this project. Based on this,
we can then add a script to the `~/.ruby_projects` folder to execute commands
that switch the Ruby Version and Gem Home as required. Looking at the provided
`sample.sh` script should make it clear how to achieve this. Simply copy it to a new
file, and base the name on what is returned by the above command.

The other file in this folder is named `reset.sh`. The values set in here should
reflect your preferred default values. This script is executed when you leave a
git repository to return your setting to normal.
