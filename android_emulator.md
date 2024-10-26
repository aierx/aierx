# 安装android sdk

scoop install android-sdk adb android-platform-tools

# 创建虚拟机

以下操作请在`powershell`进行。若在cmd使用，请使用`%userprofile%`替代`$env:userprofile`

```powershell
cd $env:userprofile\scoop\apps\android-sdk\current

tools\bin\sdkmanager.bat --help
tools\bin\sdkmanager.bat --list
tools\bin\sdkmanager.bat --install "system-images;android-33;google_apis;x86_64"
tools\bin\sdkmanager.bat --install "cmdline-tools;9.0"
tools\bin\sdkmanager.bat --install "emulator"
tools\bin\avdmanager.bat create avd

tools\bin\avdmanager.bat
tools\bin\avdmanager.bat list devices
tools\bin\avdmanager.bat create avd -k "system-images;android-33;google_apis;x86_64" -n pixel -d 17
tools\bin\avdmanager.bat list avd

tools\emulator.exe -avd pixel
# 若是arm架构的sdk需要使用如下命令
tools\emulator.exe -avd pixel_arm -qemu -machine virt

vim $env:userprofile\.android\avd\Pixel.ini
# hw.ramSize=8192

```


# root