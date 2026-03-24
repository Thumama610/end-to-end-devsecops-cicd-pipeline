### 🚀 End-to-End DevSecOps CI/CD Pipeline (Kubernetes + AWS ECR + GitHub Actions)

# 📌 Overview

This project demonstrates a complete end-to-end DevSecOps pipeline that automates the process of:

    Infrastructure provisioning using Terraform
    Kubernetes cluster setup (self-managed on EC2)
    CI/CD pipeline using GitHub Actions
    Containerization with Docker
    Secure image storage using AWS ECR
    Continuous deployment to Kubernetes
    Security scanning using Trivy
    Code quality analysis using SonarCloud

# 🏗️ Architecture
    Developer → GitHub → GitHub Actions CI/CD → AWS ECR → Kubernetes Cluster (EC2)

# ⚙️ Infrastructure Setup
    🔹 Terraform Provisioning
        1 Master Node
        2 Worker Nodes
        Instance Type: t3.xlarge
        Storage: 20GB
    🔹 Open Ports
        22       → SSH
        80/443   → Web Traffic
        6443     → Kubernetes API
        30000-32767 → NodePort Services
        3000-10000  → App Ports
        25 / 465 → Mail (optional)

# ☸️ Kubernetes Cluster Setup
    1. Initialize Master Node
      sudo kubeadm init <CIDR>
    2. Install CNI (Calico)
      kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
    3. Join Worker Nodes
      Run the kubeadm join command generated from master on each worker node.

# 🔐 AWS ECR Integration
    Attach IAM Role
    
    Attach ECR Read-Only IAM role to all EC2 instances.

# Create Docker Registry Secret
        ECR_TOKEN="$(aws ecr get-login-password --region us-east-1)"
        
        kubectl create secret docker-registry ecr-secret \
          --docker-server=https://{AWS_ID}.dkr.ecr.{AWS_REGION}.amazonaws.com \
          --docker-username=AWS \
          --docker-password=${ECR_TOKEN}

# 🔄 ECR Auto-Refresh (CronJob + RBAC)

    To prevent ECR token expiration, a Kubernetes CronJob is used.
    
    🔹 Secret
    apiVersion: v1
    kind: Secret
    metadata:
      name: ecr-helper-secrets
    type: Opaque
    stringData:
      AWS_ACCESS_KEY_ID: AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY: AWS_SECRET_ACCESS_KEY

# 🔹 ConfigMap
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: ecr-helper-cm
    data:
      AWS_REGION: "AWS_REGION"
      AWS_ACCOUNT: "AWS_ACCOUNT"
      DOCKER_SECRET_NAME: "ecr-secret"

# 🔹 RBAC Configuration
    Role → manage secrets
    ServiceAccount → used by CronJob
    RoleBinding → connects them
    verbs:
      - delete
      - create

# 🔁 CI/CD Pipeline (GitHub Actions)
    🔹 Workflow Stages
    1. 🏗️ Build
    Compile using Maven
    2. 🧪 Test
    Run unit tests
    3. 🔐 Security Scan
    Filesystem scan using Trivy
    4. 📊 Code Quality
    Analyze using SonarCloud
    5. 📦 Artifact Build
    Generate .jar file
    Upload artifact
    6. 🐳 Docker مراحل
    Build image
    Scan image with Trivy
    Push to AWS ECR
    7. ✏️ Manifest Update
    Inject new image tag dynamically using sed
    8. 🚚 Deploy to Server
    Copy YAML files via scp
    9. ☸️ Apply to Kubernetes
    kubectl apply -f deployment-service.yaml
    kubectl apply -f ecr-registry-helper-cronjob.yaml

# 🔑 Required GitHub Secrets
    Secret Name	Description
    AWS_USER_ACCESS_KEY	AWS Access Key
    AWS_USER_SECRET_ACCESS_KEY	AWS Secret
    ACCOUNT_ID	AWS Account ID
    EC2_IP_ADDRESS	Public IP of master node
    EC2_USERNAME	EC2 SSH user
    EC2_PRIVATE_KEY	SSH private key
    SONAR_TOKEN	SonarCloud token

# 🌐 Accessing the Application

    After deployment:
    
    kubectl get svc
    Copy NodePort (range: 30000-32767)
    Access via:
    http://<NODE_IP>:<NODE_PORT>

# 🔥 Key Features
    ✅ Fully automated CI/CD pipeline
    ✅ DevSecOps best practices
    ✅ Kubernetes self-managed cluster
    ✅ Secure ECR integration
    ✅ Automatic ECR token refresh
    ✅ Image vulnerability scanning
    ✅ Code quality enforcement
    ✅ Zero-downtime deployment (K8s rolling updates)

# ⚠️ Challenges Solved
    ❌ ECR token expiration → ✅ solved via CronJob
    ❌ Private registry auth issues → ✅ solved via secrets + IAM
    ❌ Manual deployment → ✅ fully automated
    ❌ Security blind spots → ✅ integrated scanning

# 📈 Future Improvements
    Use EKS instead of self-managed cluster
    Add Helm charts
    Implement Ingress Controller
    Add Monitoring (Prometheus + Grafana)
    Use ArgoCD (GitOps)

# 👨‍💻 Author

      Thumama Alrawwad
