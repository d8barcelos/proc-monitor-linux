<h1 align="center">Process Monitor</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Crystal-000000?style=for-the-badge&logo=crystal&logoColor=white" alt="Crystal"/>
  <img src="https://img.shields.io/badge/CLI-000000?style=for-the-badge&logo=windows-terminal&logoColor=white" alt="CLI"/>
  <img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux"/>
</p>

<p align="center">A lightweight and colorful command-line process monitoring tool built with Crystal.</p>

---

## ✨ Features

- 📋 List all running processes with CPU and memory usage
- 🔍 Search processes by name
- ⚡ Kill processes by PID
- 🎨 Color-coded CPU and memory usage indicators
- 📊 JSON output support

## 🚀 Installation

1. Ensure you have Crystal installed:
```bash
# On Debian/Ubuntu
apt-get install crystal

# On Fedora
dnf install crystal

# On macOS
brew install crystal
```

2. Clone and build:
```bash
git clone https://github.com/yourusername/process-monitor
cd process-monitor
crystal build src/proc_monitor.cr -o proc_monitor
```

## 💻 Usage

```bash
./proc_monitor [options]
```

### Options

| Option | Description |
|--------|-------------|
| `--list` | List all processes |
| `--search <name>` | Search processes by name |
| `--kill <PID>` | Kill a process by PID |
| `--json` | Display output in JSON format |

## 📝 Examples

**List all processes:**
```bash
./proc_monitor --list
```

**Search for a specific process:**
```bash
./proc_monitor --search chrome
```

**Kill a process:**
```bash
./proc_monitor --kill 1234
```

**Get JSON output:**
```bash
./proc_monitor --list --json
```

---

<p align="center">
Made with 💜 using Crystal
</p>