# 🧙‍♂️ DFIR-ExtracTux
DFIR Tool for Linux System to collect and gather all kind of data in case of compromised system.

## To do
- [ ] Code DEAD option
- [ ] Fully support RedHat
- [ ] Fully Support BSD 
- [ ] Fully Support MacOS
- [ ] Code External Module part
- [ ] Add More Commands

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

