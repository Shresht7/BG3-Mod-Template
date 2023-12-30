# How to use the Template

- [How to use the Template](#how-to-use-the-template)
  - [Scripts](#scripts)
    - [`Setup`](#setup)
    - [`Build`](#build)
  - [`.vscode`](#vscode)
  - [Placeholders](#placeholders)
  - [`meta.lsx`](#metalsx)
  - [`.gitkeep`](#gitkeep)
  - [`README.md`](#readmemd)
  - [License](#license)

---

## Scripts

### `Setup`

`Scripts/__Setup__.ps1` is a PowerShell script to automatically setup the mod workspace using this template by providing it the necessary information. You don't have to use it, but it can speed up the process.

> Note: The script (and the folder itself) can be removed once it is no longer needed.

The script will:
1. Rename all placeholder files and directories to whatever you specify.
2. Substitute the placeholder values in the file-contents.
3. Remove unneeded files (like `.gitkeep`).

To run the script, enter the following command in a PowerShell console:

```pwsh
. .\Scripts\__Setup__.ps1
```

You can specify parameters like so:

```pwsh
. .\Scripts\__Setup__.ps1 -Name MyMod -Author Shresht7 -UUID (New-Guid)
```

> NOTE: Like any other script, **read it before you run it**.

### `Build`

The `Scripts/Build.ps1` script will build the mod `.pak` using the `divine.exe` cli from [lslib](https://github.com/Norbyte/lslib). The build artifacts will be put in the `Build` directory.

> `NOTE`: This script expects the `divine.exe` to be in your Environment Path Variable.

To run the `Build.ps1` script, enter the following in a PowerShell console:

```pwsh
. .\Build.ps1
```

> Note: To perform a dry-run, make use of the `-WhatIf` parameter
> ```pwsh
> . .\Scripts\Build.ps1 -WhatIf
> ```

If you wish to archive the built `.pak`, you can pass in the `-Archive` switch. This will output a `.zip` file instead.

```pwsh
. .\Build.ps1 -Archive
```

> NOTE: Again, Like any other script, **read it before you run it**

## `.vscode`

The template contains useful snippets and settings to aid your development process. You can tweak these settings as you like.

A `Build Package` task has been pre-defined in `tasks.json` that runs the [`Build.ps1`](#build) script. [Note: this needs `divine.exe` ([lslib](https://github.com/Norbyte/lslib)) to be set in your Environment Path Variable]

> Tip: `Ctrl` + `Shift` + `B` keybind will run the build task

The one thing you should look at here is the `Lua.workspace.library` field in the `.vscode/settings.json` file. This should point at the directory containing the IDEHelpers. Change this to wherever you keep the IDEHelpers in your system. This will allow the lua extension to read the globals from those scripts and make them available in this workspace.

```
{
    "Lua.workspace.library": [
        "C:\Path\to\IDEHelpers\"
    ]
}
```

## Placeholders

The template, naturally, contains placeholder values. You'll want to deal with them as soon as possible.

1. Rename the project root `_____MODNAME_____` to whatever you want the name of the project to be.

2. Rename `_____MODNAME___________MODUUID_____` folder in the `Mods` directory with the appropriate values.

3. Perform a regex search for `_{5}\w+?_{5}` to list all the placeholders across the workspace. Replace these placeholders with the values relevant to you.

> **NOTE**: If your project does not need a particular folder, you can probably delete it. (e.g. the `Public` directory)

## `meta.lsx`

The `meta.lsx` is a very important file that contains the metadata information about your mod. You may want to look into this file; at least for the placeholders.

## `.gitkeep`

`.gitkeep` is a special file that tells git to track even empty directories. You can safely **remove** these (and the empty directories) if you wish.

## `README.md`

This is the heart and soul of your project's documentation. Use this file to describe what the project is about, how to make use of it and any other relevant information.

## License

You should **absolutely** take a look at the License file and make changes. You may want to change/replace the License file for your project.
