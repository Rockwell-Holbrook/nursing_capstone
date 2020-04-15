# nursing_capstone
IT Capstone Project - Bluetooth Stethescope



### Backend

Helpful

* https://github.com/byu-oit/awslogin - How to use BYU awslogin CLI tool: 
* https://www.terraform.io/intro/index.html - What is Terraform
* https://learn.hashicorp.com/terraform/getting-started/install.html - Install Terraform

To get started make sure you are logged into the proper AWS account. Once you have cloned the directory to your local compupter, cd into the backend-ENV (dev or prd) and run ```terraform init```.

Once the init is done you can make changes to terraform and the lambda code and then run ```terraform apply``` to see all the changes that will occure.

Type ```yes``` or ```no``` to commit these changes to the AWS account that you are logged into.

**Setting Up Your Mobile Development Environment**

**Overview**

The computers come installed with Android Studio. To get a full development environment set up, we will:

  1. Download an emulator through Android Studio.
  2. Download Visual Studio Code (VS Code).
  3. Download the Flutter SDK for Windows
  4. Open a Flutter project in VS Code
  5. Install Git
  6. Test the project on the emulator from VSCode
  7. Build and Run in Android Studio
  8. Build and Run in Xcode

**Detailed Steps**

First, an update is needed. Open a terminal and run the command:

gpupdate/force

...then type &quot;y&quot; to log off; then log back on.

\*\*Download an emulator through Android Studio:

- Open Android Studio. The first time you open it you will need to go through the Setup Wizard. We only need Android Studio for its emulator, so you can keep all default configurations.
- Once you are done with the Wizard, it will start a large download of needed components. This will take a few minutes.
- After the download completes, click &#39;configure&#39; in the bottom right. It is a dropdown menu. Select &#39;AVD Manager&#39; and wait for the next window to pop up
- Click &#39;Create Virtual Device&#39;
- For today, let&#39;s just download the Pixel 2. As we get further into things we can try other devices. Click &#39;Pixel 2&#39; so that it&#39;s row is highlighted, then click Next.
- Select the system image &#39;Pie&#39; and click the download button on its row.
- Another large download will start, wait a few minutes.
- Click &#39;Finish&#39; when it is done. You will be navigated back to the page you started the download from.
- Click on &#39;Pie&#39; so that the row it is on is highlighted. Click Next.
- Click Finish.
- You will now return to the AVD Manager.
- Inside the virtual devices editor, under emulated performance in the graphics options, select &quot;Hardware - GLES 2.0&quot;
- Return to the AVD Manager.
- Click the play button under the &#39;Actions&#39; column and run your emulator!

(After the emulator is launched, you can close Android Studio and the AVD Manager)

\*\*Download Visual Studio Code

- Go to: [https://code.visualstudio.com/download](https://code.visualstudio.com/download)
- Click the download button for windows
- Run the executable that downloads
- Leave all settings in the Setup Wizard alone. Just click &#39;next&#39; until it starts the setup.
- When it finishes, open Visual Studio Code.
- Open the Extensions menu. The menu is found on the far left banner and looks like this: ![](RackMultipart20200415-4-1hj8rcv_html_c1a1b4c3e0f73f1f.png)
- In the menu that opens, search &#39;Flutter&#39;.
- Click on the green install button.

\*\*Download the Flutter SDK:

- Go to: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Select &#39;Windows&#39;
- Under the &#39;Get The Flutter SDK&#39; section, click the big blue button to download the zip
- Find the zip folder in Downloads, and extract it all.
- Move the extracted folder to Documents.
- Update the path:
  - From the Start search bar, type &#39;env&#39; and select Edit environment variables for your account
  - Under User variables check if there is an entry called Path:
  - If the entry does exist, append the full path to flutter\bin using ; as a separator from existing values.

**EXAMPLE:** C:\altera\91\modelsim\_ase\win32aloem;C:\Users\tevincs\AppData\Local\Programs\Microsoft VS Code\bin; **C:\Users\--Your user account name--\Documents\flutter\bin**

![](RackMultipart20200415-4-1hj8rcv_html_5bc3cb6c7b002b4a.png)

  - If the entry does not exist, create a new user variable named Path with the full path to flutter\bin as its value.

- Test your setup by opening up command prompt and running the command: &#39;flutter --version. If this tells you what version of flutter you have, then you have installed the flutter SDK correctly.

\*\*Download Git:

- Go to [https://git-scm.com/download/win](https://git-scm.com/download/win)
- Click on the executable in the browser once it finishes downloading
- Navigate through the setup wizard. Do not change any settings.
- Click Finish.
- Update the path:

  - From the Start search bar, type &#39;env&#39; and select Edit environment variables for your account
  - Under User variables check if there is an entry called Path:
  - If the entry does exist, append the full path to flutter\bin using ; as a separator from existing values.

**EXAMPLE:** C:\altera\91\modelsim\_ase\win32aloem;C:\Users\tevincs\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\--Your user account name--\Documents\flutter\bin;C:\Program Files\Git\bin

![](RackMultipart20200415-4-1hj8rcv_html_20e7ca2de7428de7.png)

- Test your setup by opening up command prompt and running the command: &#39;git --version&#39;. If you installed correctly, it will tell you the version of Git you have.

\*\*Cloning and running the project from VSCode:

- Open VS Code
- Select File -\&gt; Add Folder to Workspace
- A File Explorer window will open. In it, create a new folder (name it whatever you want), and click on it. Once it is highlighted, click &#39;Add.&#39;
- Now type ctrl+shift+P (this will open the command palette in VS code)
- Run the command: Git: Clone
- If you have done everything up to this point correctly, it will ask you to enter a URL. Type [https://github.com/ccteng/nursing\_capstone](https://github.com/ccteng/nursing_capstone)
- It will begin the download of our project. Authenticate with your github account when prompted.
- When this completes, type ctrl+`
- In the terminal that just opened, run the command &#39;flutter run&#39;

**If everything is setup, you will see the app launch in the emulator!**

\*\*Build and Run from Android Studio

(For more detail, see [https://flutter.dev/docs/deployment/android](https://flutter.dev/docs/deployment/android))

- Open the project in VSCode
- Find the &#39;android&#39; directory in your project
- Open that directory in Android Studio
- Within Android Studio, you can simply hit the play button to run the app on an emulator
- You can also build an APK from Build-\&gt;Build Bundle(s) / APK(s)-\&gt;Build APK(s)
- When the APK is completed, a dialogue will appear giving you the option to locate the APK in File Explorer.

\*\*Build and Run from Xcode

(For more detail, see [https://flutter.dev/docs/deployment/ios](https://flutter.dev/docs/deployment/ios))

- Open the project in VSCode
- Find the &#39;ios/Runner.xcworkspace&#39; directory in your project
- Open that directory in Xcode
- Within Xcode, you can run the project on an emulator by simply hitting the play button.
- You can also archive the project for publishing by specifying the build to be for a generic device. The click Product-\&gt;Archive

\*\*After Running Terraform

Running Terraform will change the user pool IDs and app client IDs needed to run the app. Access AWS through the web console and go to the Cognito service. Then open the admin user pool and add the adminPoolID and as well as the adminAppClientID to lib/data/ids.dart within the Flutter project. Do the same for the general user pool. When you are done, ids.dart should look like this:

  String userPoolID = &#39;us-west-2\_jHUyTi4jF&#39;;

  String adminPoolID = &#39;us-west-2\_SrOMVtqVD&#39;;

  String appClientID = &#39;iicpdglhedrsh8fr5bqp0sb73&#39;;

  String adminAppClientID = &#39;3acurksh5jm4hum2vuptnagq9d&#39;;