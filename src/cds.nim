import os, strutils
import ./cds/config, ./cds/storage, ./cds/commands, ./cds/types

proc showUsage() =
  echo "Usage: cds save <alias> | cds <alias> | cds list"
  echo "  save <alias>  - Save current directory with alias"
  echo "  cds c <alias> <command>   Add command to execute when entering directory"
  echo "  list          - List all saved aliases"
  echo "  <alias>       - Jump to saved directory"

proc main() =
  let config = getDefaultConfig()
  var paths = initStorage(config)

  if paramCount() == 0:
    showUsage()
    quit(1)

  let cmd = paramStr(1)

  try:
    case cmd
    of "save":
      if paramCount() < 2:
        raise newException(AppError, "Usage: cds save <alias>")

      let alias = paramStr(2)
      handleSaveCommand(config, paths, alias)

    of "c", "configure":
      if paramCount() < 3:
        raise newException(AppError, "Usage: cds c <alias> <command>")

      let alias = paramStr(2)
      let command = paramStr(3)
      handleConfigureCommand(config, paths, alias, command)

    of "list":
      handleListCommand(paths)

    of "help", "--help", "-h":
      showUsage()

    else:

      let alias = cmd
      let resultStr = handleJumpCommand(paths, alias)

      let parts = resultStr.split("|CDS_COMMANDS|")
      let targetPath = parts[0]

      echo targetPath

      if parts.len > 1:
        let commands = parts[1].split("|CDS_SEP|")
        echo "|CDS_EXECUTE|" & commands.join(";")

  except AppError as e:
    stderr.writeLine("Error: ", e.msg)
    quit(1)
  except Exception as e:
    stderr.writeLine("Unexpected error: ", e.msg)
    quit(1)

when isMainModule:
  main()
