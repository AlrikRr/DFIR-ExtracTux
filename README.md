<a href="https://github.com/AlrikRr/DFIR-ExtracTux/blob/master/LICENSE"><img alt="GitHub license" src="https://img.shields.io/github/license/AlrikRr/DFIR-ExtracTux"></a>
<a href="https://github.com/AlrikRr/DFIR-ExtracTux/stargazers"><img alt="GitHub stars" src="https://img.shields.io/github/stars/AlrikRr/DFIR-ExtracTux"></a>
<a href="https://github.com/AlrikRr/DFIR-ExtracTux/network"><img alt="GitHub forks" src="https://img.shields.io/github/forks/AlrikRr/DFIR-ExtracTux"></a>
<a href="https://github.com/AlrikRr/DFIR-ExtracTux/issues"><img alt="GitHub issues" src="https://img.shields.io/github/issues/AlrikRr/DFIR-ExtracTux"></a>


# 🧙‍♂️ DFIR-ExtracTux
DFIR Tool for Linux System to collect and gather all kind of data in case of compromised system.

## To do
- [ ] Code DEAD option
- [ ] Fully support RedHat
- [ ] Fully Support BSD 
- [ ] Fully Support MacOS
- [ ] Code External Module part
- [ ] Add More Commands

## Collect

 ⚠️ Do not hesitate to contribute on the collect part !

- Audit-Risk
  - Plain Text Passwords
  - SSH Keys
- Users & Groups
  - Passwd and shadow files
  - Groups 
  - Temp users
  - Sudoers
- System Configuration
  - Network settings
  - OS Release
  - Disks
- User Activities (For each users)
  - Bash history
  - Recently changed files
- Log System
  - All kind of logs
  - SSH, Apache, etc
- Persistence Mechanism
  - Services
  - Processes
  - Crontab
  - Network Connection
  - TMP folder backup

## Usage

Use Root privilege to start the script  
```shell
chmod +x dfir-extractux.sh
sudo ./dfir-extractux.sh
```

Display Help menu  
```shell
sudo ./dfir-extractux.sh -h

Syntax: dfir-extractux.sh [ -h | -l | -d ]
options:
-h      Print this help.
-l      LIVE - Use this option of you are working directly on the system
-d      DEAD - Use this option of you are working on a mounted disk

````

![Live Demo](/assets/usage_demo.gif)

## Live

Use this option if you are working on a live aquisition machine.  

### Setup Working DIR

This folder can be your USB key or a shared folder.  
Save all the output in a single place.  

![Live Demo](/assets/live_workingdir.gif)

### Extract 
You can then chose the option to extract everything or a specific module.  

![Live Demo](/assets/live_demo_extract.gif)

### Save ZIP
You can save all the result inside a password protected zip file.  
If you want to pass this step, just CRTL+C the programm and you'll get your folder not zipped.  

![Live Demo](/assets/live_demo_zip.gif)


## Dead - TBD

⚠️ Working on it

