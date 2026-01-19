# Warden: Automated System Monitor & Log Manager

**Warden** is a lightweight, modular shell scripting tool designed to help System Administrators monitor server health, audit user activity, and manage log rotation through automation.

## Features

- **System Health Checks**: Monitors Disk Usage, RAM, and identifies CPU-intensive processes.
- **User Auditing**: Tracks human users (UID >= 1000) and identifies who is currently active.
- **Automated Log Rotation**: Finds `.log` files older than a configurable threshold, compresses them into `.tar.gz`, and archives them.
- **Configuration Driven**: No need to edit the source code; adjust thresholds and paths via `warden.conf`.
- **Modular Architecture**: Logic is split into specialized scripts for better maintainability.

## Project Structure

```text
.
├── warden.sh          # Main entry point
├── warden.conf        # Configuration settings
├── system_state.sh    # Hardware monitoring logic
├── user_audit.sh      # User tracking logic
├── archive_logs.sh    # Log cleanup and compression logic
└── README.md          # Documentation
```

## Installation & Setup
1. Clone the repository:
```Bash
git clone https://github.com/yourusername/warden.git
cd warden
```

2. Set permissions:
```Bash
chmod +x warden.sh
```

3. Configure your settings: Edit `warden.conf` to match your environment:
```Bash
nano warden.conf
```

## Usage
Run the script with the following flags:
```text
Flag            Description
--report        Displays CPU, Memory, and Disk health.
--useraudit     Lists standard users and their login status.
--cleanup       Archives logs based on the config threshold.
--all           Runs all of the above.--helpShows the help menu. 
```

### Example:
```Bash
./warden.sh --report
```

## Running Tests
To run the automated test suite:
```bash
chmod +x test_warden.sh
./test_warden.sh
```

```bash
sudo apt install bats
bats warden.bats 
```

## Automated Scheduling (Cron)
To run the warden cleanup automatically every Sunday at midnight, add this to your crontab (use `crontab -e` to edit):
```bash
Code snippet0 0 * * 0 /full/path/to/warden.sh --cleanup
```

## License
This project is open-source and available under the MIT License.
---

## Contributing

If you would like to contribute, please follow these steps:

1. Fork repo.
2. Create feature branch: `git checkout -b feature/your-feature`.
3. Commit changes and push.
4. Open a Pull Request.

## Author

Ukeme Wilson

- <a href="https://www.linkedin.com/in/ukeme-wilson-4825a383/">Linkedin</a>.
- <a href="https://medium.com/@ukemeboswilson">Medium</a>.
- <a href="https://www.ukemewilson.site/">Website</a>.