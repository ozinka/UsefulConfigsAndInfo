# Sublime Plugin

A comprehensive Sublime Text plugin that enhances your editing experience with custom themes, smart bullet lists, snippets, and syntax highlighting for configuration files.

## Features

### 🎨 Custom Themes
- Beautiful, carefully crafted color schemes
- Optimized for readability and reduced eye strain
- Multiple theme variants to suit different preferences

### 📝 Auto Bullets
Smart bullet list management that automatically continues and formats your lists:

#### Symbol Bullets
- Supports `-`, `*`, and `•` bullet characters
- Automatically converts `*` to `•` for consistent formatting
- Maintains proper indentation levels

#### Numbered Lists
- Recognizes `number + dot + space` pattern (e.g., `1. `, `42. `)
- Automatically increments numbers when creating new list items
- Preserves indentation and formatting

#### Smart Behavior
- **Empty bullet removal**: Press Enter on an empty bullet to remove it and exit the list
- **Automatic continuation**: Press Enter after bullet text to create the next bullet
- **Indentation preservation**: Maintains consistent spacing throughout your lists

### 🔧 Code Snippets
Pre-built code snippets for faster development and writing:
- Common programming patterns
- Frequently used text structures
- Customizable and expandable snippet library

### 🎯 Custom Syntax Highlighting
Enhanced syntax highlighting for plain text configuration files:
- **TXT files**: Improved readability for plain text documents
- **CFG files**: Specialized highlighting for configuration files
- **Custom patterns**: Recognizes common configuration syntax patterns

## Installation

1. Open Sublime Text
2. Go to `Preferences` > `Package Control`
3. Select `Install Package`
4. Search for this plugin and install

*Or manually:*
1. Download the plugin files
2. Extract to your Sublime Text `Packages` directory
3. Restart Sublime Text

## Usage

### Auto Bullets
1. Start typing a bullet list using `-`, `*`, or `•` followed by a space
2. Press `Enter` to automatically create the next bullet
3. For numbered lists, start with `1. ` and press `Enter` to continue
4. Press `Enter` on an empty bullet to exit the list

### Themes
1. Go to `Preferences` > `Color Scheme`
2. Select one of the included custom themes

### Snippets
1. Type the snippet trigger word
2. Press `Tab` to expand the snippet
3. Use `Tab` to navigate between snippet fields

### Syntax Highlighting
- Open `.txt` or `.cfg` files to automatically apply custom syntax highlighting
- Syntax highlighting will enhance readability of configuration patterns

## Configuration

You can customize the plugin behavior by modifying the settings:

```json
{
    "auto_bullets_enabled": true,
    "custom_syntax_enabled": true,
    "theme_variant": "default"
}
