# log_parser
A Small collection of scripts to parse log files.  
Main reason for creating this was to remove duplicate entries when working with log files, notably when using log errors in monitoring software alerts.

## Usage
Check the configuration file and modify it to your needs.  
Run the script as follows:  
`./LogParser.pl --file (file or direcotry) --config (config file)`  
If no config file is provided the script will use parser.conf in the current directory.
The output will be redirected to stdout.  

For now there are sill some features that have not been implemented, but they can easily be replaced with bash.  
To get the output to file just add redirect it by adding `> report.log` at the end of the command.  
The awk scrips can be ran by themselves, usage examples can be found in the comments of said scripts.

