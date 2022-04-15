<h1 align="center">
  <br>
  <img src="https://camo.githubusercontent.com/7aa45eaab667b13a31d0fbf73e7ecdeb0e8c0369c799b32affd1d6ad6985362d/68747470733a2f2f7374617469632e77696b69612e6e6f636f6f6b69652e6e65742f6d696e6563726166745f67616d6570656469612f696d616765732f322f32312f42617272656c5f253238552532395f4a45315f4245312e706e672f7265766973696f6e2f6c61746573743f63623d3230323030323234323230343233" alt="HopperEngine Logo" width="256">
  <br>
</h1>

<h2 align="center">Barrel CLI</h4>
<h4 align="center">Utilities for creating and running both stateless and stateful servers in dockerized and non-dockerized environments</h4>

<p align="center">
    <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="version" src="https://img.shields.io/badge/version-1.0 Pre Release-brightgreen"/>
    </a>
    <a href="https://discord.gg/hNF4cD4KrW">
        <img alt="discord" src="https://img.shields.io/discord/713148399787966474?label=chat&logo=discord"/>
    </a>
    <a href="https://helightdevalt.gitbook.io/hopper/" >
        <img alt="gitbook" src="https://img.shields.io/badge/docs-gitbook-brightgreen"/>
    </a>
</p>
<p align="center">
    <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="version" src="https://img.shields.io/badge/supports-1.18.2-blueviolet"/>
    </a>
    <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="version" src="https://img.shields.io/badge/supports-1.18.1-blueviolet"/>
    </a>
    <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="version" src="https://img.shields.io/badge/supports-1.17.1-blueviolet"/>
    </a>
    <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="version" src="https://img.shields.io/badge/supports-1.16.5-blueviolet"/>
    </a>
 <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="version" src="https://img.shields.io/badge/supports-1.12.2-blueviolet"/>
    </a>
    <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="version" src="https://img.shields.io/badge/supports-1.8.8-blueviolet"/>
    </a>
</p>
<p align="center">
    <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="flavour" src="https://img.shields.io/badge/flavour-paperspigot-blue"/>
    </a>
    <a href="https://getbukkit.org/get/RD0y91OTotryPrElNQe4ovBLDNweoO5Z/">
        <img alt="flavour" src="https://img.shields.io/badge/flavour-spigot-blue"/>
    </a>
</p>

## Installation
Install the barrel cli via dart globals
```bash
dart pub global activate barrel
```
or use the barrel installer script (for ubuntu & debian) to also install
dart and java if not already present
```bash
bash <(wget -qO- https://gist.githubusercontent.com/helightdev/3f15a696d66921b1e47d077f3243a96b/raw/6d4f1fcd3a1e70d084d40235e23c3b86b8fe7825/installer.sh)
```

## Usage
barrel < command > [ arguments ]

* **init**        Starts the barrel initializer and creates a runnable environment in the current directory.  
* **run**         Launches the operation system specific startfile.  
  * -d, --dockerized    Performs a docker build and runs the image wrapped.  
* **build**       Wraps a normal docker build command with default values.  
* **pull**        Pulls the server files based on the hopper configuration.  
* **doctor**      Snapshots and prints debug details about the current environment and image.  
