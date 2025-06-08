# 🛠️ SomoCore Stack - Scripts Directory

This directory contains convenience scripts for managing the SomoCore Stack development and deployment workflow.

## 📋 Available Scripts

### 🚀 Development Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| **`setup-env.sh`** | Initial environment setup | `./scripts/setup-env.sh` |
| **`start-all.sh`** | Start all services | `./scripts/start-all.sh` |
| **`start-dev.sh`** | Start development environment | `./scripts/start-dev.sh` |
| **`stop-all.sh`** | Stop all services | `./scripts/stop-all.sh` |
| **`status.sh`** | Check system status | `./scripts/status.sh` |

### 🧪 Testing Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| **`test-all.sh`** | Run all tests | `./scripts/test-all.sh` |
| **`test-backend.sh`** | Backend tests only | `./scripts/test-backend.sh` |
| **`test-dashboard.sh`** | Dashboard tests only | `./scripts/test-dashboard.sh` |
| **`test-mobile.sh`** | Mobile app tests only | `./scripts/test-mobile.sh` |
| **`test-integration.sh`** | Integration tests | `./scripts/test-integration.sh` |

### 🔧 Utility Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| **`logs-all.sh`** | View service logs | `./scripts/logs-all.sh [options]` |
| **`clean.sh`** | Clean environment | `./scripts/clean.sh` |
| **`deploy.sh`** | Deploy to environments | `./scripts/deploy.sh [options]` |

## 🚀 Quick Start Workflow

### First Time Setup
```bash
# 1. Set up the environment
./scripts/setup-env.sh

# 2. Start development environment
./scripts/start-dev.sh

# 3. Check everything is working
./scripts/status.sh

# 4. Run tests to verify
./scripts/test-all.sh
```

### Daily Development
```bash
# Start your day
./scripts/start-dev.sh

# Check status anytime
./scripts/status.sh

# View logs when debugging
./scripts/logs-all.sh -f

# Run tests before committing
./scripts/test-all.sh

# Stop when done
./scripts/stop-all.sh
```

### When Things Go Wrong
```bash
# Check what's running
./scripts/status.sh

# View recent logs
./scripts/logs-all.sh

# Clean and restart
./scripts/clean.sh
./scripts/setup-env.sh
./scripts/start-dev.sh
```

## 📖 Detailed Script Documentation

### `setup-env.sh`
**Purpose**: Initial environment setup and dependency installation

**Features**:
- Checks system prerequisites (Docker, Node.js, Flutter)
- Initializes Git submodules
- Creates environment files from templates
- Installs dependencies for all components

**Usage**:
```bash
./scripts/setup-env.sh
```

### `start-all.sh` vs `start-dev.sh`
- **`start-all.sh`**: Basic startup, good for production-like testing
- **`start-dev.sh`**: Development mode with hot reloading and debugging

### `logs-all.sh`
**Purpose**: View logs from all services

**Options**:
```bash
./scripts/logs-all.sh                    # Last 100 lines from all services
./scripts/logs-all.sh -f                 # Follow all logs
./scripts/logs-all.sh --backend -f       # Follow only backend logs
./scripts/logs-all.sh -n 50              # Show last 50 lines
./scripts/logs-all.sh --db               # Show only database logs
```

### `test-all.sh`
**Purpose**: Comprehensive testing across all components

**What it tests**:
- Backend: Unit tests, integration tests, linting
- Dashboard: Component tests, build validation, linting
- Mobile: Flutter tests, analysis, build validation

### `clean.sh`
**Purpose**: Clean up development environment

**Interactive cleanup options**:
- Docker containers and volumes
- node_modules directories
- Build artifacts and temporary files
- Environment files
- Package lock files
- Git state reset

### `deploy.sh`
**Purpose**: Build and deploy to different environments

**Options**:
```bash
./scripts/deploy.sh                      # Deploy to staging
./scripts/deploy.sh -e production        # Deploy to production
./scripts/deploy.sh --build-only         # Build only, don't deploy
./scripts/deploy.sh -e staging -s        # Deploy to staging, skip tests
```

## 🔧 Customization

### Adding New Scripts
1. Create your script in the `scripts/` directory
2. Make it executable: `chmod +x scripts/your-script.sh`
3. Follow the naming convention: `action-target.sh`
4. Add documentation to this README

### Script Template
```bash
#!/bin/bash

# SomoCore Stack - Your Script Name
# Brief description of what this script does

echo "🎯 Your Script Name"
echo "=================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Your script logic here

echo -e "${GREEN}✅ Script completed successfully${NC}"
```

## 🐛 Troubleshooting

### Common Issues

**Scripts not executable**:
```bash
chmod +x scripts/*.sh
```

**Docker not running**:
```bash
# Start Docker Desktop or Docker daemon
./scripts/status.sh  # Check Docker status
```

**Port conflicts**:
```bash
./scripts/status.sh  # Check which ports are in use
./scripts/stop-all.sh  # Stop all services
```

**Environment issues**:
```bash
./scripts/clean.sh  # Clean environment
./scripts/setup-env.sh  # Recreate environment
```

### Getting Help

Each script supports the `--help` flag:
```bash
./scripts/logs-all.sh --help
./scripts/deploy.sh --help
```

## 📚 Related Documentation

- [Main README](../README.md) - Project overview
- [Development Guide](../docs/DEVELOPMENT.md) - Development setup
- [Deployment Guide](../docs/DEPLOYMENT.md) - Production deployment
- [Contributing Guide](../docs/CONTRIBUTING.md) - How to contribute

## 🤝 Contributing

When adding new scripts:
1. Follow the existing naming conventions
2. Include proper error handling
3. Add colored output for better UX
4. Include help documentation
5. Update this README with your script

---

💡 **Tip**: Bookmark this directory! These scripts will make your development workflow much smoother. 