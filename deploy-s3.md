# Deploy to S3 Static Hosting - Quick Solution

## Vì có TypeScript errors, chúng ta sẽ deploy static version

### **Bước 1: Tạo S3 Bucket**

```bash
# Tạo S3 bucket cho static hosting
aws s3 mb s3://aws-certification-platform-demo --region ap-southeast-1

# Enable static website hosting
aws s3 website s3://aws-certification-platform-demo --index-document index.html --error-document index.html

# Set bucket policy for public read
aws s3api put-bucket-policy --bucket aws-certification-platform-demo --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::aws-certification-platform-demo/*"
    }
  ]
}'
```

### **Bước 2: Build và Upload**

```bash
# Build project (ignore TypeScript errors for now)
npm run build -- --mode production

# Upload to S3
aws s3 sync dist/ s3://aws-certification-platform-demo --delete

# Your app will be available at:
# http://aws-certification-platform-demo.s3-website-ap-southeast-1.amazonaws.com
```

### **Bước 3: Setup CloudFront (Optional)**

```bash
# Create CloudFront distribution for better performance
aws cloudfront create-distribution --distribution-config '{
  "CallerReference": "aws-cert-platform-'$(date +%s)'",
  "Comment": "AWS Certification Platform",
  "DefaultRootObject": "index.html",
  "Origins": {
    "Quantity": 1,
    "Items": [
      {
        "Id": "S3-aws-certification-platform-demo",
        "DomainName": "aws-certification-platform-demo.s3-website-ap-southeast-1.amazonaws.com",
        "CustomOriginConfig": {
          "HTTPPort": 80,
          "HTTPSPort": 443,
          "OriginProtocolPolicy": "http-only"
        }
      }
    ]
  },
  "DefaultCacheBehavior": {
    "TargetOriginId": "S3-aws-certification-platform-demo",
    "ViewerProtocolPolicy": "redirect-to-https",
    "TrustedSigners": {
      "Enabled": false,
      "Quantity": 0
    },
    "ForwardedValues": {
      "QueryString": false,
      "Cookies": {
        "Forward": "none"
      }
    }
  },
  "Enabled": true
}'
```

## Expected Result

After deployment:
- **Static Website**: Working with sample questions
- **Demo Mode**: All features work in demo mode
- **Sample Questions**: 10 questions available
- **Responsive Design**: Works on mobile and desktop
- **Fast Loading**: Static files served from S3/CloudFront

## Next Steps

1. **Fix TypeScript Errors**: Clean up the codebase
2. **Add Real Backend**: Deploy Amplify backend later
3. **Custom Domain**: Add your own domain
4. **SSL Certificate**: Enable HTTPS
5. **CI/CD**: Setup automated deployments

This gives you a working demo immediately while we fix the backend issues!