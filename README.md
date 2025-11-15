# PWA-Kit

<center>

![PWA-Kit](dock_screenshot.png)

**The macOS toolkit for progressive web apps**

[![Swift 5.10](https://img.shields.io/badge/Swift-5.10-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-lightgrey.svg)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](#)

</center>

---

## 🚀 About PWA-Kit

**PWA-Kit** is the macOS toolkit for turning progressive web apps into native Mac applications. Built with WebKit and Swift 5.10, PWA-Kit creates lightweight, performant apps that integrate seamlessly with macOS.

### Why PWA-Kit?

Safari's "Add to Dock" creates PWAs using **200-300MB RAM per app**. Closed-source alternatives like Unite and Coherence are expensive and have unfixable bugs. PWA-Kit is the **open-source, lightweight alternative** the macOS community needs.

**Key Features**:
- ✅ **macOS 14+ Native**: Built for Sonoma & Sequoia with modern WebKit APIs
- ✅ **Swift 5.10**: Modern, safe, performant Swift codebase
- ✅ **Memory Optimized**: Target <100MB per app (vs Safari's 200-300MB)
- ✅ **WebKit-Powered**: Native Apple rendering engine
- ✅ **Open Source**: GPL-3.0 licensed, community-driven
- ✅ **PWA Standards**: Supports Web Push, Badging, and Web App Manifest

---

## 📊 Memory Usage Comparison

| App Type | RAM per App | Total (5 apps) |
|----------|-------------|----------------|
| **Safari PWA** | 200-300MB | ~1.5GB |
| **Unite/Coherence** | 150-200MB | ~1GB |
| **PWA-Kit (target)** | <100MB | <800MB ✅ |

---

## 🎯 Project Status

**Phase 1: Modernization** ✅ Complete  
- Swift 5.4 → 5.10 migration
- macOS 11 → 14 (Sonoma) support
- WebKit API modernization
- CI/CD infrastructure (CodeQL, Swift Build)

**Phase 2: Memory Optimization** 🚧 In Progress  
- Profile and optimize memory usage
- Implement efficient caching strategies
- Target: <100MB per app

**Phase 3: GUI App Builder** 📋 Planned  
- Visual app creation tool
- Drag & drop interface
- One-click PWA deployment

**Target v1.0**: February 2026

---

## 🛠️ Installation

### Homebrew (Recommended)

```bash
brew install pwa-kit
```

### Build from Source

```bash
git clone https://github.com/chindris-mihai-alexandru/PWA-Kit.git
cd PWA-Kit
swift build --configuration release
```

---

## 📖 Quick Start

### Create a PWA

```bash
# Create a Gmail PWA
pwa-kit create https://gmail.com --name Gmail

# Custom icon
pwa-kit create https://twitter.com --name Twitter --icon ~/icons/twitter.png

# Specify scope (advanced)
pwa-kit create https://github.com --name GitHub --scope /dashboard
```

### Manage PWAs

```bash
# List all PWAs
pwa-kit list

# Remove a PWA
pwa-kit remove Gmail

# Update a PWA
pwa-kit update Gmail --url https://mail.google.com
```

---

## 🌟 Features

### Progressive Web App Standards

- **Web App Manifest** - Customize name, icons, display mode
- **Web Push** - Native macOS notifications
- **Badging** - App badge support
- **Service Workers** - Offline functionality
- **Focus Modes** - Sync notification preferences across devices

### macOS Integration

- **Dock Integration** - Apps appear in Dock, Launchpad, Spotlight
- **Stage Manager** - Full Stage Manager support
- **Mission Control** - Works seamlessly with Mission Control
- **Keychain Integration** - AutoFill from iCloud Keychain
- **Permissions** - System-level camera, mic, location permissions

### Developer Features

- **Swift Package Manager** - Modern dependency management
- **WebKit Engine** - Native Apple rendering
- **Custom URL Schemes** - Launch apps from anywhere
- **Sandboxing** - Secure, isolated app environments
- **Hot Reload** - Fast development iteration

---

## 📚 Documentation

- [Getting Started Guide](docs/getting-started.md)
- [Web App Manifest Reference](docs/manifest.md)
- [API Documentation](docs/api.md)
- [Contributing Guide](CONTRIBUTING.md)
- [Roadmap](ROADMAP.md)
- [Strategic Decisions](DECISIONS.md)

---

## 🔒 Security

PWA-Kit takes security seriously:

- **CodeQL Advanced** scanning on every commit
- **Sandboxed apps** with limited system access
- **System permissions** for camera, mic, location
- **Responsible disclosure** policy ([SECURITY.md](SECURITY.md))

Report vulnerabilities to: chindris.mihai.alexandru@gmail.com

---

## 🗺️ Roadmap

### Phase 1: Modernization ✅ (Complete)
- [x] Swift 5.10 + macOS 14 support
- [x] WebKit API updates
- [x] CI/CD infrastructure
- [x] Security hardening

### Phase 2: Memory Optimization 🚧 (In Progress)
- [ ] Profile current memory usage
- [ ] Implement efficient caching
- [ ] Optimize WebView lifecycle
- [ ] Target: <100MB per app

### Phase 3: Swift 6.0 Migration 📋 (Planned)
- [ ] Enable strict concurrency checking
- [ ] Remove `nonisolated(unsafe)` usage
- [ ] Modernize error handling
- [ ] Full Swift 6 compliance

### Phase 4: GUI App Builder 📋 (Planned)
- [ ] Visual app creation tool
- [ ] Template library
- [ ] One-click deployment
- [ ] App Store packaging

---

## 🤝 Contributing

PWA-Kit is community-driven! We welcome contributions:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📜 License

PWA-Kit is licensed under the GNU General Public License v3.0.

This project is a modernization of [MacPin](https://github.com/kfix/MacPin) by kfix, originally licensed under GPL-3.0. We maintain GPL-3.0 licensing to honor the original work and keep PWA-Kit open source.

See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- **kfix** - Original MacPin creator ([kfix/MacPin](https://github.com/kfix/MacPin))
- **Apple WebKit Team** - Modern PWA support in macOS
- **Swift Community** - Tools and language improvements
- **Contributors** - Everyone who helps improve PWA-Kit

---

## 📱 Contact & Support

- **GitHub Issues**: [Report bugs](https://github.com/chindris-mihai-alexandru/PWA-Kit/issues)
- **Discussions**: [Community forum](https://github.com/chindris-mihai-alexandru/PWA-Kit/discussions)
- **Security**: chindris.mihai.alexandru@gmail.com
- **Website**: Coming soon at `pwakit.app`

---

<center>

**Built with ❤️ using Swift and WebKit**

[⭐ Star us on GitHub](https://github.com/chindris-mihai-alexandru/PWA-Kit) | [📖 Read the Docs](docs/) | [🐛 Report Issues](https://github.com/chindris-mihai-alexandru/PWA-Kit/issues)

</center>
