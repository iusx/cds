import os, json, strutils
import ./types, ./storage

proc handleSaveCommand*(config: AppConfig, paths: var JsonNode, alias: string) =

  if alias.len == 0:
    raise newException(AppError, "Alias cannot be empty")

  let targetPath = getCurrentDir()
  validateDirectory(targetPath)

  var entry: DirectoryEntry
  entry.path = targetPath
  entry.commands = @[]

  paths[alias] = toJson(entry)
  saveStorage(config, paths)
  echo "Saved path '", alias, "' -> ", targetPath

proc handleConfigureCommand*(config: AppConfig, paths: var JsonNode, alias: string, command: string) =

  if alias.len == 0:
    raise newException(AppError, "Alias cannot be empty")

  if not paths.hasKey(alias):
    raise newException(AppError, "Alias not found: " & alias)

  var entry = parseDirectoryEntry(paths[alias])
  entry.commands.add(command)

  paths[alias] = toJson(entry)
  saveStorage(config, paths)
  echo "Added command '", command, "' to alias '", alias, "'"

proc handleListCommand*(paths: JsonNode) =

  if paths.len == 0:
    echo "No saved paths found."
    return

  for k, v in paths:
    let entry = parseDirectoryEntry(v)
    if dirExists(entry.path):
      echo k, " -> ", entry.path
      if entry.commands.len > 0:
        echo "    Commands: ", entry.commands.join(", ")
    else:
      echo k, " -> ", entry.path, " (invalid directory)"

proc handleJumpCommand*(paths: JsonNode, alias: string): string =

  if not paths.hasKey(alias):
    raise newException(AppError, "Alias not found: " & alias)

  let entry = parseDirectoryEntry(paths[alias])
  validateDirectory(entry.path)

  var resultStr = entry.path
  if entry.commands.len > 0:
    resultStr &= "|CDS_COMMANDS|" & entry.commands.join("|CDS_SEP|")

  return resultStr
