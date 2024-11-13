# 🧹 archcleaner

> An intelligent system cleanup utility for Arch Linux that manages pacman cache, unused dependencies, and system configurations.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Support-1793D1?logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/justkelvin/archcleaner/graphs/commit-activity)

## Features

- 📦 **Smart Package Cache Management**
  - Maintains configurable number of recent package versions
  - Removes obsolete package cache files
  - Shows space savings after cleanup

- 🔍 **Dependency Analysis**
  - Identifies and removes orphaned packages
  - Safe removal of unused dependencies
  - Prevents system breakage

- ⚙️ **Configuration Cleanup**
  - Scans common configuration directories
  - Removes broken symlinks
  - Interactive cleanup of backup files

- 📝 **Journal Management**
  - Optimizes systemd journal size
  - Maintains recent system logs
  - Configurable retention policies

## Installation

```bash
# Clone the repository
git clone https://github.com/justkelvin/archcleaner.git

# Enter the directory
cd archcleaner

# Make the script executable
chmod +x archcleaner.sh

# Optional: Move to system path
sudo cp archcleaner.sh /usr/local/bin/archcleaner
```

## Usage

```bash
# Run with default settings
sudo archcleaner

# Or if not in PATH
sudo ./archcleaner.sh
```

The script will guide you through each cleaning operation with interactive prompts.

## Requirements

- Arch Linux
- Root privileges
- Required packages:
  - `pacman-contrib`
  - `fd`

## Configuration

Default settings can be modified by editing the following variables in the script:

```bash
CACHE_VERSIONS_TO_KEEP=2      # Number of package versions to keep
JOURNAL_SIZE="500M"           # Maximum journal size
OLD_CONFIG_DIRS=(             # Directories to scan for old configs
    "$HOME/.config"
    "$HOME/.cache"
    "$HOME/.local/share"
)
```

## Screenshots

![ArchCleaner in Action](screenshots/archcleaner-demo.png)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Upcoming Features

- [ ] GUI interface using zenity/yad
- [ ] Configuration file support
- [ ] Scheduled cleaning operations
- [ ] Backup creation before cleaning
- [ ] More granular control over cleanup operations
- [ ] Integration with other package managers (yay, paru)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by various Arch Linux maintenance practices
- Thanks to the Arch Linux community for feedback and suggestions
- Built with love for the Arch Linux ecosystem

## Support

If you find this project helpful, please consider:
- Starring the repository
- Reporting issues
- Contributing to the code
- Sharing it with other Arch Linux users

## Author

Your Name ([@justkelvin](https://github.com/justkelvin))
