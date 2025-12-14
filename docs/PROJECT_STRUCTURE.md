# Project Structure

This document outlines the organization of the cloud-resume-challenge repository.

## Directory Structure

```
cloud-resume-challenge/
├── .github/
│   └── workflows/
│       └── complete-cicd.yml     # GitHub Actions CI/CD pipeline
├── docs/
│   ├── DEVELOPMENT.md            # Development guide
│   └── PROJECT_STRUCTURE.md      # This file
├── infra/
│   ├── main.tf                   # S3 and Route53 configuration
│   ├── lambda.tf                 # Lambda and API Gateway configuration
│   ├── provider.tf               # AWS provider configuration
│   ├── variables.tf              # Terraform variables
│   ├── outputs.tf                # Terraform outputs
│   └── backend.tf                # State backend configuration
├── lambda/
│   ├── index.js                  # Lambda entry point
│   ├── commands.js               # Terminal commands handler
│   ├── package.json              # Node.js dependencies
│   ├── jest.config.js            # Jest testing configuration
│   └── .eslintrc.js              # ESLint configuration
├── scripts/
│   └── deploy.sh                 # Manual deployment script
├── website/
│   ├── css/                      # Stylesheets
│   ├── js/                       # JavaScript files
│   ├── images/                   # Images and assets
│   ├── icon-fonts/               # Font icons
│   └── index.html                # Main terminal interface
├── .env.example                  # Environment template
├── .gitignore                    # Git ignore patterns
├── Makefile                      # Build automation
└── README.md                     # Project documentation
```

## Key Components

### Infrastructure (`infra/`)
- **Terraform configurations** for AWS resources
- **Modules** for reusable infrastructure components
- **Provider configurations** for AWS integration

### Lambda Functions (`lambda/`)
- **Source code** for serverless functions
- **Libraries** for shared functionality
- **Tests** for quality assurance
- **Configuration** for testing and linting

### Frontend (`website/`)
- **Static website** files
- **Assets** including CSS, JS, and images
- **Third-party libraries** (Font Awesome, jQuery)

### CI/CD (`.github/workflows/`)
- **GitHub Actions** workflows
- **Automated testing** and deployment
- **Quality gates** and security checks

### Scripts (`scripts/`)
- **Deployment scripts** for manual operations
- **Utility scripts** for development

### Documentation (`docs/`)
- **Project documentation**
- **Feature-specific guides**
- **Architecture diagrams**

## File Naming Conventions

- **Terraform files**: `*.tf`
- **Lambda functions**: `*.js`
- **Test files**: `*.test.js` or `*/__tests__/*.js`
- **Configuration files**: `.*rc.js`, `*.config.js`
- **Documentation**: `*.md`
- **Scripts**: `*.sh`

## Development Workflow

1. **Code changes** in `lambda/` or `website/`
2. **Tests run** locally and in CI/CD
3. **Infrastructure changes** in `infra/`
4. **Deployment** via GitHub Actions on push to `main`

## Security Considerations

- **Environment variables** stored in `.env` (gitignored)
- **AWS credentials** configured in GitHub Secrets
- **Sensitive files** excluded via `.gitignore`
- **Code quality** enforced via ESLint and Jest

## Getting Started

1. Clone the repository
2. Install dependencies: `cd lambda && npm install`
3. Configure AWS credentials
4. Run tests: `npm test`
5. Deploy: Push to `main` branch
