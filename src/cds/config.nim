import os
import ./types

proc getDefaultConfig*(): AppConfig =
  result.pathFile = getHomeDir() / ".cds_config.json"
