# FitnessGurus

Note: Backend is purposely disabled. Reach out to me david.a.eatonii@gmail.com if you wish to test the application on your personal device. Otherwise, you can watch a demo of the application at . Also code included is just the library code written, not the project's android/iOS configurations etc. 


I) For Android Device (Recommended for the project code included is just the lib files and not the OS specific files.)
    Allow Untrusted Sources.
    Please follow the documentation at https://www.verizon.com/support/knowledge-base-222186/
    for your android device. Note newer android devices will just ask you to allow this setting when 
    you try to install the application. If you have a newer device just go ahead and try to install the 
    app via the steps below. 
    
    A) Installation via Computer and USB
        1. First make sure to configure on-device developer option on your device
            and USB debugging. Follow the steps on the following web page:
            https://developer.android.com/studio/debug/dev-options
            
        2. On MacOS. Install Android File Transfer on your computer first.
            https://www.android.com/filetransfer/. If you are using a Windows PC
            you can skip this step.
            
        3. Connect Android device to computer via the Android device's USB cable.
            Allow connection via your Android device.
            
        4. Copy the fitness-gurus-challenge-android-debug.apk file within the folder Android 
            Build APK. 
            
        5. Paste that file in the downloads folder on your device via the Android File 
            Transfer Application. ('This can be done by just dragging the file over')
            
        6. Now that the transfer is complete you can disconnect your device from the USB
            cable.
            
        7. Navigate to your files directory on your device. On Samsung devices this can be 
            found under the apps/Samsung folder on your devices app screen.
            
        8. Navigate to the internal storage( or the storage where you copied the device to) and go to the downloads folder(or the folder you decided to copied the file to).
        
        9. Click the fitness-gurus-challenge-android-debug.apk file and install. Allow
            all requested privileges.
            
        10. Launch the app from your app list. Enjoy your fitness journey.
        
        
II) For iOS Device
    To create a .ipa file for iOS for to do so required owning a iOS device and registering it with Apple.
    To demo the iOS version of our app yourself you will need to follow the 
    following instruction to install flutter SDK on a MacOS computer. Please 
    review steps below:
    
    Note: I removed my personal twitter api key. For this reason I commented out the twitter api section.
    
    A) Getting Flutter and your android emulator or iOS emulator.

        1. To install Flutter follow the steps for your OS.
            https://flutter.dev/docs/get-started/install

    B) Launching the application on your emulator.

        1. Set up your IDE (Recommended IDE is vsCode) note you will still need android studio to create an android emulator.
            https://code.visualstudio.com/download 
            
        2. From vsCode open fitness_gurus_challenger
        
        3. After the project is open. Go to the lib folder and select pubspec.yaml in the file listing window.
        
        4. Go ahead and initiate a save (cmd save on mac) to do a flutter pub get. Also make
            sure you’re running flutter on the latest version on its stable channel.
            Steps to do this can be found on:
            https://flutter.dev/docs/development/tools/sdk/upgrading
        
        5. Alternatively you can run the command flutter pub get in the terminal within the project directory.
        
        6. From the top menu, select run, then run without debugging.
        
        7. Choose your device iOS (if you have a MacOS only) or Android
            This process may take a little time the first time.
            Your emulator should launch up and from there you can create an account or sign in with a social media account.
