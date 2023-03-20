Some basic scripts

## Server Setup
1. ServerInit.sh
  - Secure Server setup.
  - Intended to auto-run on server startup.
2. BlockStorage.sh
  - Attach Vultr block storage to server
  - Run manually by cloning this repo and running
3. Nextcloud.sh
  - Setup a nextcloud server using Snap
  - Run manually by cloning this repo and running
4. SystemUpdater.sh
  - Installs the System76 System Updater
  - Does this via the Pop!_OS PPA, but uses apt preferences
    to only install the System Updater
  - Sets auto updates to once a week

## System Setups
The order of scripts that should be run to get a functioning system

A. Nextcloud Server
  1. ServerInit.sh (Should be run by cloud provider)
  2. BlockStorage (If planning to use Vultr BlockStorage)
  3. SystemUpdater.sh
  4. Nextcloud.sh (Figure out how to use blockstorage)
  
