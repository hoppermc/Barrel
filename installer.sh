if ! command -v dart &> /dev/null
then
    printf "Installing dart..."
    sudo apt-get update
    sudo apt-get install apt-transport-https
    wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
    echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
    sudo apt-get update
    sudo apt-get install dart
    prinf "Setting up environment variables..."
    export PATH="$PATH:/usr/lib/dart/bin"
    export PATH="$PATH":"$HOME/.pub-cache/bin"
    echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile
    echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.profile
fi

if ! command -v java &> /dev/null
then
    printf "Installing openjdk-17..."
    sudo apt-get install openjdk-17-jre -y
fi

prinf "Installing barrel via dart pub..."
dart pub global activate barrel