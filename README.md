<h1 align="center">
  <br>
  <img src="https://static.wikia.nocookie.net/minecraft_gamepedia/images/2/21/Barrel_%28U%29_JE1_BE1.png/revision/latest?cb=20200224220423" alt="HopperEngine Logo" width="256">
  <br>
</h1>

<h2 align="center">Barrel CLI</h4>
<h4 align="center">Utilities for running and creating stateless  
docker images for minecraft server primarily for minigames</h4>

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

## Usage
barrel < command > [ arguments ]

* **init**        Starts the barrel initializer and creates a runnable environment in the current directory.  
* **run**         Launches the operation system specific startfile.  
  * -d, --dockerized    Performs a docker build and runs the image wrapped.  
* **build**       Wraps a normal docker build command with default values.  
* **pull**        Pulls the server files based on the hopper configuration.  
* **doctor**      Snapshots and prints debug details about the current environment and image.  