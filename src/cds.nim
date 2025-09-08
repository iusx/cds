import os, strutils
import ./cds/config, ./cds/storage, ./cds/commands, ./cds/types

proc showUsage() =
  echo "Usage: cds save <alias> | cds <alias> | cds list"
  echo "  save <alias>  - Save current directory with alias"
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

    of "list":
      handleListCommand(paths)

    else:
      let alias = cmd
      let targetPath = handleJumpCommand(paths, alias)
      echo targetPath

  except AppError as e:
    stderr.writeLine("Error: ", e.msg)
    quit(1)
  except Exception as e:
    stderr.writeLine("Unexpected error: ", e.msg)
    quit(1)

when isMainModule:
  main()
