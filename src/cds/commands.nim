import os, json
import ./types, ./storage

proc handleSaveCommand*(config: AppConfig, paths: var JsonNode, alias: string) =

  if alias.len == 0:
    raise newException(AppError, "Alias cannot be empty")

  let targetPath = getCurrentDir()
  validateDirectory(targetPath)

  paths[alias] = newJString(targetPath)
  saveStorage(config, paths)
  echo "Saved path '", alias, "' -> ", targetPath

proc handleListCommand*(paths: JsonNode) =

  if paths.len == 0:
    echo "No saved paths found."
    return

  var hasValidPaths = false
  for k, v in paths:
    let path = v.getStr()
    if dirExists(path):
      echo k, " -> ", path
      hasValidPaths = true
    else:
      echo k, " -> ", path, " (invalid directory)"

  if not hasValidPaths:
    echo "No valid directories found in saved paths."

proc handleJumpCommand*(paths: JsonNode, alias: string): string =

  if not paths.hasKey(alias):
    raise newException(AppError, "Alias not found: " & alias)

  let targetPath = paths[alias].getStr()
  validateDirectory(targetPath)
  return targetPath
