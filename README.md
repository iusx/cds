# cds
A lightweight CLI tool to save and quickly jump to frequently used directories using simple aliases.

```
Usage: cds save <alias> | cds <alias> | cds list
or run cds -h:

Usage: cds save <alias> | cds <alias> | cds list
  save <alias>  - Save current directory with alias
  cds c <alias> <command>   Add command to execute when entering directory
  list          - List all saved aliases
  <alias>       - Jump to saved directory
```

## compile

```
nim c -d:release nim c -o:cds src/cds.nim

# or use:
nimble build
nimble install

save csd to ~/.nimble/bin/cds
```

### config file

```
~/.cds_config.json: 
{
  "iusx": "/Users/uwu/Code/My/iusx",
  "config-git": "/Users/uwu/Code/My/dotfiles"
}
```


## Todo
cds next plan list:

* [ ] **TUI**: For example, when using `c list`, you can search for shortcuts.
* [x] **Execute scripts automatically**: After entering a directory via `c c iusx`, automatically execute the script commands recorded in `~/.cds_config.json`.
* [ ] **Auto**: Can record automatically. For example, when in `/Users/uwu/Code/My/iusx`, it automatically records `iusx: /Users/uwu/Code/My/iusx`.
