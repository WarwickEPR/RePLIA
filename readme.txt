RePLIA - FPGA Based Lock-in Amplifier
-------------------------------------
NOTE: Many people have had versioning issues due to (I think) updates to the STEMlab software which don't gel well with the RePLIA
software. The easiest way around this is for us to upload a disk image of our installation of RePLIA. However, GitHub will not allow
files of this size (~4 GB), and so I have uploaded to Google Drive here:
https://drive.google.com/file/d/1AOVsBOMCaBl7kWWVk9TnJfYykbBjvgp8/view?usp=sharing

Google will undoubtedly warn you about viruses and file size, and there will be no preview, but it's all clean.
With this install, the default user and password are 'root' and 'nvmag'. Please change them after installing.
-------------------------------------
This software is provided under the terms of the GNU v3 (2007).

The folder marked FPGA contains the relevant files for manipulating the FPGA software. 

If you only wish to use the RePLIA and not make any changes to the FPGA, you can ignore this folder.
Transfer all files from within the RP folder to the /root/tmp folder of the STEMlab.

The LIAControl folder contains all the necessary files for that application. This must remain on the host computer, and requires an up-to-date version of Java. 
Double-click the LIAControl.jar file to begin after installation of the RePLIA on the STEMlab.

Full Instructions can be found in the user manual.
