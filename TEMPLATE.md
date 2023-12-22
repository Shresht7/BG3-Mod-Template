# How to use the Template

- [How to use the Template](#how-to-use-the-template)
  - [`.vscode`](#vscode)
  - [Placeholders](#placeholders)
  - [`meta.lsx`](#metalsx)
  - [`.gitkeep`](#gitkeep)
  - [`README.md`](#readmemd)
  - [License](#license)


## `.vscode`

The template contains useful snippets and settings to aid your development process. You can tweak these settings as you like.

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
