import os, json, strutils
import ./types

proc initStorage*(config: AppConfig): JsonNode =

  if fileExists(config.pathFile):
    try:
      let content = readFile(config.pathFile)
      if content.strip().len == 0:
        result = newJObject()
      else:
        result = parseJson(content)
        if result.kind != JObject:
          result = newJObject()
    except JsonParsingError:
      echo "Warning: Invalid JSON in config file, creating new one."
      result = newJObject()
    except:
      echo "Warning: Error reading config file, creating new one."
      result = newJObject()
  else:
    result = newJObject()

proc saveStorage*(config: AppConfig, paths: JsonNode) =

  try:
    writeFile(config.pathFile, pretty(paths))
  except:
    raise newException(AppError, "Could not write to config file: " & config.pathFile)

proc validateDirectory*(path: string) =

  if not dirExists(path):
    raise newException(AppError, "Directory does not exist: " & path)
