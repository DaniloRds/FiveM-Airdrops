----------------------- [ Unity ] -----------------------
-- GitHub: https://github.com/DaniloRds
-- Discord: https://discord.gg/pbT5wVp8e9
-- Contact: unitystorefivem@gmail.com
-- Author: Tio Dan#9894
-- Name: Airdrops 
-- Version: 1.0.0
-- Link: 
----------------------- [ Unity ] -----------------------
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

server_scripts {
  '@vrp/lib/utils.lua',
  'server.lua'
}

client_scripts{
  'client.lua'
}