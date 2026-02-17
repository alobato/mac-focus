# mac-focus

A macOS command-line tool that returns information about the currently focused UI element in JSON format.

## Features

- Returns detailed information about the focused element including:
  - Application name and bundle ID
  - Element role, subrole, title, and description
  - Position and size coordinates
  - Current value (e.g., text field content)
  - Process ID (PID)

## Installation

### Quick Install (Recommended)

Once you've published this repository to GitHub, users can install it with:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/mac-focus/main/install.sh | bash
```

**Before publishing:** Replace `YOUR_USERNAME` with your GitHub username in:
- `README.md` (this file)
- `install.sh` (line with the curl command)

### Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/YOUR_USERNAME/mac-focus.git
cd mac-focus
```

2. Compile the Swift script:
```bash
swiftc -o mac-focus mac_focus.swift -framework ApplicationServices -framework Cocoa
```

3. Move the binary to a directory in your PATH (optional):
```bash
sudo mv mac-focus /usr/local/bin/
```

Or install it locally:
```bash
mkdir -p ~/.local/bin
mv mac-focus ~/.local/bin/
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Usage

Simply run `mac-focus` to get information about the currently focused UI element:

```bash
mac-focus
```

**Tip:** To capture the focused element after a delay, use `sleep`:

```bash
sleep 3 && mac-focus
```

### Example Output

```json
{
  "subrole" : "",
  "bundleId" : "com.google.Chrome",
  "title" : "",
  "appName" : "Google Chrome",
  "position" : {
    "x" : 206,
    "y" : 81
  },
  "role" : "AXTextField",
  "description" : "Address and search bar",
  "size" : {
    "height" : 24,
    "width" : 1363
  },
  "pid" : 382,
  "value" : "youtube.com/watch?v=768oFX9sSB0"
}
```

### Error Output

If no application is in focus:
```json
{"error":"no_frontmost_app"}
```

If no element is focused:
```json
{"error":"no_focused_element"}
```

## Requirements

- macOS (uses macOS Accessibility APIs)
- Swift compiler (included with Xcode Command Line Tools)
- Accessibility permissions (macOS may prompt you to grant accessibility access)

## Building from Source

1. Ensure you have Xcode Command Line Tools installed:
```bash
xcode-select --install
```

2. Compile:
```bash
swiftc -o mac-focus mac_focus.swift -framework ApplicationServices -framework Cocoa
```

## Permissions

macOS may require you to grant accessibility permissions to Terminal (or your terminal emulator) for this tool to work. You can grant these permissions in:

**System Settings → Privacy & Security → Accessibility**

Add your terminal application to the allowed list.

## License

[Add your license here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
