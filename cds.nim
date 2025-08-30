import os, strutils, json

let pathFile = getHomeDir() / ".cds_config.json"

var paths: JsonNode
if fileExists(pathFile):
  try:
    let content = readFile(pathFile)
    if content.strip().len == 0:
      paths = newJObject()
    else:
      paths = parseJson(content)
      if paths.kind != JObject:
        paths = newJObject()
  except JsonParsingError:
    echo "Warning: Invalid JSON in config file, creating new one."
    paths = newJObject()
  except:
    echo "Warning: Error reading config file, creating new one."
    paths = newJObject()
else:
  paths = newJObject()

if paramCount() == 0:
  echo "Usage: cds save <alias> | cds <alias> | cds list"
  quit(1)

let cmd = paramStr(1)

if cmd == "save":
  if paramCount() < 2:
    echo "Usage: cds save <alias>"
    quit(1)
  let alias = paramStr(2)
  let targetPath = getCurrentDir()

  if not dirExists(targetPath):
    echo "Error: Current directory '", targetPath, "' is not a valid directory."
    quit(1)

  paths[alias] = newJString(targetPath)
  try:
    writeFile(pathFile, pretty(paths))
    echo "Saved path '", alias, "' -> ", targetPath
  except:
    echo "Error: Could not write to config file '", pathFile, "'"
    quit(1)

elif cmd == "list":
  if paths.len == 0:
    echo "No saved paths found."
    quit(0)

  for k, v in paths:
    let path = v.getStr()
    if dirExists(path):
      echo k, " -> ", path
    else:
      echo k, " -> ", path, " (invalid directory)"

else:
  let alias = cmd
  if paths.hasKey(alias):
    let targetPath = paths[alias].getStr()
    if dirExists(targetPath):
      echo targetPath
    else:
      echo "Error: Path '", targetPath, "' for alias '", alias, "' is not a valid directory."
      quit(1)
  else:
    echo "Alias '", alias, "' not found"
    quit(1)
