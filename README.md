# Process Monitor

A simple command-line process monitoring tool built with Crystal that allows you to list, search, and manage system processes.

## Features

- List all running processes with CPU and memory usage
- Search processes by name
- Kill processes by PID
- Color-coded CPU and memory usage indicators
- JSON output support

## Installation

1. Make sure you have Crystal installed on your system
2. Clone this repository
3. Build the project:
```bash
crystal build src/proc_monitor.cr -o proc_monitor
```

## Usage

```bash
./proc_monitor [options]

Options:
  --list                List all processes
  --search <name>       Search processes by name
  --kill <PID>         Kill a process by PID
  --json               Display output in JSON format
```

## Examples

List all processes:
```bash
./proc_monitor --list
```

Search for a specific process:
```bash
./proc_monitor --search chrome
```

Kill a process:
```bash
./proc_monitor --kill 1234
```

Get JSON output:
```bash
./proc_monitor --list --json
```