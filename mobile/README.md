##Setting Up Your Development Environment

Overview
The computers come installed with Android Studio. To get a full development environment set up, we will:
1.	Download an emulator through Android Studio. 
2.	Download Visual Studio Code (VS Code). 
3.	Download the Flutter SDK for Windows
4.	Open a Flutter project in VS Code
5.	Install Git
6.	Test the project on the emulator from VSCode
7.	Build and Run in Android Studio
8.	Build and Run in Xcode
Detailed Steps
	First, an update is needed. Open a terminal and run the command:
 	gpupdate/force
...then type "y" to log off; then log back on.

**Download an emulator through Android Studio:
•	Open Android Studio. The first time you open it you will need to go through the Setup Wizard. We only need Android Studio for its emulator, so you can keep all default configurations.
•	Once you are done with the Wizard, it will start a large download of needed components. This will take a few minutes.
•	After the download completes, click ‘configure’ in the bottom right. It is a dropdown menu. Select ‘AVD Manager’ and wait for the next window to pop up
•	Click ‘Create Virtual Device’
•	For today, let’s just download the Pixel 2. As we get further into things we can try other devices. Click ‘Pixel 2’ so that it’s row is highlighted, then click Next.
•	Select the system image ‘Pie’ and click the download button on its row.
•	Another large download will start, wait a few minutes.
•	Click ‘Finish’ when it is done. You will be navigated back to the page you started the download from.
•	Click on ‘Pie’ so that the row it is on is highlighted. Click Next.
•	Click Finish.
•	You will now return to the AVD Manager.
•	Inside the virtual devices editor, under emulated performance in the graphics options, select "Hardware - GLES 2.0"
•	Return to the AVD Manager.
•	 Click the play button under the ‘Actions’ column and run your emulator!
(After the emulator is launched, you can close Android Studio and the AVD Manager)


**Download Visual Studio Code
•	Go to: https://code.visualstudio.com/download
•	Click the download button for windows
•	Run the executable that downloads
•	Leave all settings in the Setup Wizard alone. Just click ‘next’ until it starts the setup.
•	When it finishes, open Visual Studio Code.
•	Open the Extensions menu. The menu is found on the far left banner and looks like this:  
•	In the menu that opens, search ‘Flutter’.
•	Click on the green install button.












**Download the Flutter SDK:
•	Go to: https://flutter.dev/docs/get-started/install
•	Select ‘Windows’
•	Under the ‘Get The Flutter SDK’ section, click the big blue button to download the zip
•	Find the zip folder in Downloads, and extract it all.
•	Move the extracted folder to Documents.
•	Update the path:
o	From the Start search bar, type ‘env’ and select Edit environment variables for your account
o	Under User variables check if there is an entry called Path:
o	If the entry does exist, append the full path to flutter\bin using ; as a separator from existing values.
EXAMPLE: C:\altera\91\modelsim_ase\win32aloem;C:\Users\tevincs\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\--Your user account name--\Documents\flutter\bin
 
o	If the entry does not exist, create a new user variable named Path with the full path to flutter\bin as its value.

•	Test your setup by opening up command prompt and running the command: ‘flutter --version. If this tells you what version of flutter you have, then you have installed the flutter SDK correctly.



**Download Git:
•	Go to https://git-scm.com/download/win
•	Click on the executable in the browser once it finishes downloading
•	Navigate through the setup wizard. Do not change any settings.
•	Click Finish.
•	Update the path:

o	From the Start search bar, type ‘env’ and select Edit environment variables for your account
o	Under User variables check if there is an entry called Path:
o	If the entry does exist, append the full path to flutter\bin using ; as a separator from existing values.
EXAMPLE: C:\altera\91\modelsim_ase\win32aloem;C:\Users\tevincs\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\--Your user account name--\Documents\flutter\bin; C:\Program Files\Git\bin

 
•	Test your setup by opening up command prompt and running the command: ‘git --version’. If you installed correctly, it will tell you the version of Git you have.


**Cloning and running the project from VSCode:
•	Open VS Code
•	Select File -> Add Folder to Workspace
•	A File Explorer window will open. In it, create a new folder (name it whatever you want), and click on it. Once it is highlighted, click ‘Add.’
•	Now type ctrl+shift+P (this will open the command palette in VS code)
•	Run the command:  Git: Clone
•	If you have done everything up to this point correctly, it will ask you to enter a URL. Type https://github.com/ccteng/nursing_capstone
•	It will begin the download of our project. Authenticate with your github account when prompted.
•	When this completes, type ctrl+`
•	In the terminal that just opened, run the command ‘flutter run’

If everything is setup, you will see the app launch in the emulator!

	**Build and Run from Android Studio
		(For more detail, see https://flutter.dev/docs/deployment/android)
•	Open the project in VSCode
•	Find the ‘android’ directory in your project
•	Open that directory in Android Studio
•	Within Android Studio, you can simply hit the play button to run the app on an emulator
•	You can also build an APK from Build->Build Bundle(s) / APK(s)->Build APK(s)
•	When the APK is completed, a dialogue will appear giving you the option to locate the APK in File Explorer.
**Build and Run from Xcode 
(For more detail, see https://flutter.dev/docs/deployment/ios)

•	Open the project in VSCode
•	Find the ‘ios/Runner.xcworkspace’ directory in your project
•	Open that directory in Xcode
•	Within Xcode, you can run the project on an emulator by simply hitting the play button.
•	You can also archive the project for publishing by specifying the build to be for a generic device. The click Product->Archive
**After Running Terraform
Running Terraform will change the user pool IDs and app client IDs needed to run the app. Access AWS through the web console and go to the Cognito service. Then open the admin user pool and add the adminPoolID and as well as the adminAppClientID to lib/data/ids.dart within the Flutter project. Do the same for the general user pool. When you are done, ids.dart should look like this: 
  String userPoolID = 'us-west-2_jHUyTi4jF';
  String adminPoolID = 'us-west-2_SrOMVtqVD';
  String appClientID = 'iicpdglhedrsh8fr5bqp0sb73';
  String adminAppClientID = '3acurksh5jm4hum2vuptnagq9d';

