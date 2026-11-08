#!/bin/bash

# AWS Certification Platform - Deployment Script
# This script automates the deployment process

echo "Starting AWS Certification Platform Deployment..."
echo "=================================================="

# Check if Amplify CLI is installed
if ! command -v amplify &> /dev/null; then
    echo "Amplify CLI not found. Please install it first:"
    echo "npm install -g @aws-amplify/cli"
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS CLI not configured or credentials invalid"
    echo "Please run: aws configure"
    exit 1
fi

echo "Prerequisites check passed"

# Build frontend
echo "Building frontend application..."
npm run build

if [ $? -ne 0 ]; then
    echo "Frontend build failed"
    exit 1
fi

echo "Frontend build successful"

# Deploy backend
echo "Deploying backend infrastructure..."
amplify push --yes

if [ $? -ne 0 ]; then
    echo "Backend deployment failed"
    exit 1
fi

echo "Backend deployment successful"

# Deploy frontend
echo "Deploying frontend to Amplify Hosting..."
amplify publish --yes

if [ $? -ne 0 ]; then
    echo "Frontend deployment failed"
    exit 1
fi

echo "Frontend deployment successful"

# Get deployment info
echo "Deployment Information:"
echo "=========================="
amplify status

echo ""
echo "Deployment completed successfully!"
echo "Your AWS Certification Platform is now live!"
echo ""
echo "Next steps:"
echo "1. Configure custom domain (optional)"
echo "2. Import sample questions"
echo "3. Create admin users"
echo "4. Set up monitoring alerts"
echo ""
echo "For support, check the documentation in the docs/ folder"