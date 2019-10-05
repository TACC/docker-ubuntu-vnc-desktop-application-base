FROM taccaci/docker-ubuntu-vnc-desktop_application_base 

# Install STKO
RUN apt update \ 
    && apt upgrade -y \
    && apt install build-essential -y

RUN apt update \
    && apt install -y \
    python3-dev \
    tcl8.6-dev \
    tk8.6-dev \ 
    libtogl-dev \
    libglu1-mesa-dev \
    freeglut3-dev \
    mesa-common-dev \
    mesa-utils \
    libxi-dev \
    libxmu-dev \
    libxkbcommon-x11-0

# Add stko executable
ADD STKO-Install /STKO-Install
# Use/overwrite script so that it uses qt libs that will be installed by online installer
COPY STKO.sh /STKO-Install/STKO.sh

# Install qt 5.12.4 using online installer
COPY qt_install_utils/ /qt_temp
ADD http://download.qt.io/official_releases/qt/5.12/5.12.4/qt-opensource-linux-x64-5.12.4.run /qt_temp/qt-opensource-linux-x64-5.12.4.run
RUN chmod +x /qt_temp/qt-opensource-linux-x64-5.12.4.run
RUN /qt_temp/qt-opensource-linux-x64-5.12.4.run --script /qt_temp/qt-installer.qs -platform minimal
RUN rm -rf /qt_temp

# Replace application script with script running stko 
COPY application.sh /
