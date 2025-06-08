# 🏫 SomoCore Stack - Complete Educational Platform

<div align="center">

![SomoCore Logo](https://via.placeholder.com/200x80/2563eb/ffffff?text=SomoCore)

**A comprehensive, multi-tenant SaaS platform for school management across Kenya and beyond**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Microservices](https://img.shields.io/badge/architecture-microservices-brightgreen)](https://microservices.io/)
[![Docker](https://img.shields.io/badge/docker-ready-blue)](https://www.docker.com/)
[![Status](https://img.shields.io/badge/status-active%20development-orange)](https://github.com)

</div>

## 📖 Overview

SomoCore is a modern, scalable multi-tenant education management platform designed specifically for African schools. This monorepo contains the complete stack including backend API, mobile application, and admin dashboard.

### 🎯 Mission
To democratize access to quality school management software across Kenya and Africa by providing an affordable, comprehensive, and culturally-relevant platform.

## 🏗️ Repository Structure

This repository uses **Git Submodules** to manage separate components:

```
somocore-stack/
├── 🔧 backend/           # Node.js API (somocore-backend)
├── 📱 mobile/            # Flutter App (somocore-mobile)  
├── 🎛️ dashboard/         # React Dashboard (somocore-dashboard)
├── 📜 scripts/           # Development & deployment scripts
├── 📚 docs/              # Complete documentation
└── 🐳 docker-compose/    # Multi-service orchestration
```

### 📦 Component Repositories

| Component | Repository | Technology | Purpose |
|-----------|------------|------------|---------|
| **Backend API** | [somocore-backend](https://github.com/your-org/somocore-backend) | Node.js + Express | Multi-tenant REST API |
| **Mobile App** | [somocore-mobile](https://github.com/your-org/somocore-mobile) | Flutter + Dart | iOS/Android mobile app |
| **Admin Dashboard** | [somocore-dashboard](https://github.com/your-org/somocore-dashboard) | Next.js + React | Web admin interface |

## ⚡ Quick Start (5 Minutes)

### Prerequisites
- **Docker** & Docker Compose
- **Git** with submodule support
- **Node.js** ≥18.0.0 (for local development)

### 1. Clone with Submodules
```bash
# Clone main repository with all submodules
git clone --recursive https://github.com/your-org/somocore-stack.git
cd somocore-stack

# If already cloned, initialize submodules
git submodule update --init --recursive
```

### 2. Environment Setup
```bash
# Copy environment templates
cp .env.example .env
cp backend/.env.example backend/.env
cp dashboard/.env.example dashboard/.env.local

# Configure your settings (see Configuration section)
```

### 3. Start Complete Platform
```bash
# Start all services with Docker
docker-compose up -d

# Or use the convenience script
./scripts/start-all.sh
```

### 4. Access Services
| Service | URL | Credentials |
|---------|-----|-------------|
| **Admin Dashboard** | http://localhost:3001 | admin@demo.com / password |
| **API Documentation** | http://localhost/docs | N/A |
| **Backend Health** | http://localhost/health | N/A |
| **Mobile App** | Flutter run | Demo credentials available |

## 🎯 Core Features

### 🏛️ Multi-Tenant Architecture
- **Complete data isolation** between schools
- **Scalable infrastructure** supporting thousands of schools
- **Tenant-aware** API with automatic filtering
- **Centralized billing** and subscription management

### 📊 Academic Management
| Module | Status | Features |
|--------|--------|----------|
| 🎓 **Student Management** | ✅ Active | Registration, profiles, attendance |
| 👨‍🏫 **Teacher Portal** | ✅ Active | Class management, grading |
| 💰 **Finance System** | 🔧 Beta | Fee tracking, M-Pesa integration |
| 📝 **Examination** | 📋 Planned | Online exams, report generation |
| 📚 **Library** | 📋 Planned | Catalog, circulation, digital resources |
| 🚌 **Transport** | 📋 Planned | Route management, tracking |

### 🔐 Security & Compliance
- **JWT Authentication** with role-based access
- **Data encryption** at rest and in transit
- **GDPR compliant** data handling
- **Audit trails** for all operations
- **Multi-factor authentication** support

## 🚀 Development Workflows

### For Backend Development
```bash
# Work on backend only
cd backend
npm install
npm run dev

# Run backend tests
npm run test
```

### For Mobile Development
```bash
# Work on mobile app
cd mobile
flutter pub get
flutter run

# Test on different devices
flutter run -d "iPhone 14 Pro"
flutter run -d android
```

### For Dashboard Development
```bash
# Work on dashboard
cd dashboard
npm install
npm run dev

# Access at http://localhost:3001
```

### Full Stack Development
```bash
# Start all services for integrated development
./scripts/start-dev.sh

# Watch logs from all services
./scripts/logs-all.sh

# Stop all services
./scripts/stop-all.sh
```

## 🐳 Docker Services

### Core Services
```yaml
# docker-compose.yml
services:
  backend:      # Node.js API
  dashboard:    # Next.js web app
  mongodb:      # Primary database
  redis:        # Cache & sessions
  nginx:        # Reverse proxy
  minio:        # File storage
  mailhog:      # Email testing
```

### Service Ports
| Service | Internal | External | Purpose |
|---------|----------|----------|---------|
| Backend API | 3000 | 80 (via nginx) | REST API |
| Dashboard | 3001 | 3001 | Web interface |
| MongoDB | 27017 | 27017 | Database |
| Redis | 6379 | 6379 | Cache |
| MinIO | 9000/9001 | 9000/9001 | File storage |
| MailHog | 1025/8025 | 8025 | Email testing |

## 📚 Documentation

### 🚀 Getting Started
- **[Quick Start Guide](./docs/QUICK_START.md)** - Get running in 5 minutes
- **[Installation Guide](./docs/INSTALLATION.md)** - Detailed setup instructions
- **[Configuration](./docs/CONFIGURATION.md)** - Environment configuration

### 🏗️ Architecture
- **[System Architecture](./docs/ARCHITECTURE.md)** - Complete system design
- **[API Documentation](./docs/API.md)** - REST API reference
- **[Database Schema](./docs/DATABASE.md)** - Data model documentation
- **[Security Guide](./docs/SECURITY.md)** - Security implementation

### 👥 Development
- **[Contributing Guide](./docs/CONTRIBUTING.md)** - How to contribute
- **[Development Setup](./docs/DEVELOPMENT.md)** - Local development
- **[Testing Guide](./docs/TESTING.md)** - Testing strategies
- **[Deployment Guide](./docs/DEPLOYMENT.md)** - Production deployment

### 📱 Component Guides
- **[Backend Development](./backend/README.md)** - API development
- **[Mobile Development](./mobile/README.md)** - Flutter app development
- **[Dashboard Development](./dashboard/README.md)** - React dashboard development

## 🧪 Testing Strategy

### Automated Testing
```bash
# Run all tests across all components
./scripts/test-all.sh

# Component-specific testing
./scripts/test-backend.sh
./scripts/test-mobile.sh
./scripts/test-dashboard.sh

# Integration testing
./scripts/test-integration.sh
```

### Test Coverage
- **Backend**: Unit tests, integration tests, API tests
- **Mobile**: Widget tests, integration tests, E2E tests
- **Dashboard**: Component tests, E2E tests with Playwright
- **Integration**: Cross-service API tests

## 🚀 Deployment Options

### 1. Development (Docker Compose)
```bash
docker-compose up -d
```

### 2. Staging (Docker Swarm)
```bash
docker stack deploy -c docker-compose.staging.yml somocore
```

### 3. Production (Kubernetes)
```bash
kubectl apply -f k8s/
```

### 4. Cloud Deployment
- **AWS**: ECS, RDS, ElastiCache
- **Google Cloud**: GKE, Cloud SQL, Memorystore
- **Azure**: AKS, Azure Database, Redis Cache

## 🔧 Configuration

### Environment Variables
```bash
# Main configuration (.env)
ENVIRONMENT=development
DOMAIN=localhost
DATABASE_URL=mongodb://localhost:27017/somocore
REDIS_URL=redis://localhost:6379

# Backend specific (backend/.env)
JWT_SECRET=your-super-secure-secret
NODE_ENV=development
PORT=3000

# Dashboard specific (dashboard/.env.local)
NEXT_PUBLIC_API_URL=http://localhost/api/v1
NEXTAUTH_SECRET=your-nextauth-secret
```

### Multi-Tenant Configuration
```bash
# Tenant management
DEFAULT_TENANT=demo-school
TENANT_ISOLATION=database
SUBSCRIPTION_MODEL=freemium
```

## 👥 Team Collaboration

### Git Workflow
```bash
# Update all submodules
git submodule update --remote

# Work on specific component
cd backend
git checkout -b feature/new-api-endpoint
# ... make changes ...
git commit -m "Add new API endpoint"
git push origin feature/new-api-endpoint

# Update main repository
cd ..
git add backend
git commit -m "Update backend submodule"
```

### Code Review Process
1. **Feature branches** in component repositories
2. **Pull requests** for component changes
3. **Integration testing** in main repository
4. **Submodule updates** in main repository

## 📊 Monitoring & Analytics

### Health Monitoring
- **API Health**: `/health` endpoints
- **Database**: Connection and query monitoring
- **Cache**: Redis performance metrics
- **Storage**: MinIO availability and capacity

### Analytics Dashboard
- **User engagement** metrics
- **System performance** monitoring
- **Business intelligence** reporting
- **Cost optimization** insights

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](./docs/CONTRIBUTING.md) for details.

### Quick Contribution Steps
1. **Fork** this repository
2. **Clone** with submodules: `git clone --recursive`
3. **Create** feature branch in appropriate component
4. **Make** your changes with tests
5. **Submit** pull request to component repository
6. **Update** submodule reference in main repository

## 🌟 Roadmap

### Phase 1: Foundation (✅ Complete)
- ✅ Multi-tenant backend architecture
- ✅ Basic mobile app with offline support
- ✅ Admin dashboard foundation
- ✅ Docker development environment

### Phase 2: Core Features (🔧 In Progress)
- 🔧 Complete student management
- 🔧 Teacher portal with grading
- 🔧 Parent portal and communication
- 🔧 Financial management with M-Pesa

### Phase 3: Advanced Features (📋 Planned Q2 2024)
- 📋 Online examination system
- 📋 Library management
- 📋 Transport and logistics
- 📋 Advanced analytics and reporting

### Phase 4: Scale & Enterprise (🌟 Q4 2024)
- 🌟 Multi-region deployment
- 🌟 Advanced integrations (Google Classroom, etc.)
- 🌟 AI-powered insights
- 🌟 White-label solutions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with ❤️ for the education sector in Kenya and beyond
- Special thanks to all contributors and the open-source community
- Inspired by the need for accessible, quality education management tools

## 🆘 Support & Community

### 📞 Support Channels
- **📚 Documentation**: [Full Documentation](./docs/)
- **🐛 Issues**: [GitHub Issues](https://github.com/your-org/somocore-stack/issues)
- **💬 Discussions**: [GitHub Discussions](https://github.com/your-org/somocore-stack/discussions)
- **📧 Email**: support@somocore.com

### 🌍 Community
- **Discord**: [Join our community](https://discord.gg/somocore) (Coming Soon)
- **Twitter**: [@SomoCore](https://twitter.com/somocore) (Coming Soon)
- **LinkedIn**: [SomoCore Company Page](https://linkedin.com/company/somocore) (Coming Soon)

---

<div align="center">

**[⬆ Back to Top](#-somocore-stack---complete-educational-platform)**

Made with ❤️ by the SomoCore Team | [🚀 Get Started](./docs/QUICK_START.md) | [🏛️ Architecture](./docs/ARCHITECTURE.md) | [🔌 API Docs](./docs/API.md)

</div> 