# AWS DevOps Workshop Infrastructure Architecture

## Complete Infrastructure Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                    Internet                                         │
└─────────────────────────────────┬───────────────────────────────────────────────────┘
                                  │
                         ┌────────▼─────────┐
                         │ Internet Gateway │
                         └────────┬─────────┘
                                  │
┌─────────────────────────────────▼───────────────────────────────────────────────────┐
│                              VPC (10.0.0.0/16)                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │                        Public Subnets                                       │    │
│  │  ┌─────────────────────────┐     ┌─────────────────────────┐                │    │
│  │  │   PublicSubnetOne       │     │   PublicSubnetTwo       │                │    │
│  │  │   (10.0.0.0/24)         │     │   (10.0.1.0/24)         │                │    │
│  │  │   AZ-1                  │     │   AZ-2                  │                │    │
│  │  │                         │     │                         │                │    │
│  │  │  ┌─────────────────┐    │     │                         │                │    │
│  │  │  │   NAT Gateway   │    │     │                         │                │    │
│  │  │  │  (EIP Attached) │    │     │                         │                │    │
│  │  │  └─────────────────┘    │     │                         │                │    │
│  │  └─────────────────────────┘     └─────────────────────────┘                │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
│                                      │                                              │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │                 Application Load Balancer (ALB)                             │    │
│  │                    Name: alb-devops-workshop                                │    │
│  │  ┌─────────────────────┐     ┌─────────────────────┐                        │    │
│  │  │   Listener :80      │     │   Listener :8080    │                        │    │
│  │  │   (Production)      │     │   (Test)            │                        │    │
│  │  └─────────────────────┘     └─────────────────────┘                        │    │
│  │            │                           │                                    │    │
│  │  ┌─────────▼─────────┐       ┌─────────▼─────────┐                          │    │
│  │  │ TargetGroupPublic │       │DummyTargetGroup   │                          │    │
│  │  │ecs-devops-webapp  │       │ecs-devops-webapp │                           │    │
│  │  │      -TG          │       │     -TG-tmp       │                          │    │
│  │  └───────────────────┘       └───────────────────┘                          │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
│                                      │                                              │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │                        Private Subnets                                      │    │
│  │  ┌─────────────────────────┐     ┌─────────────────────────┐                │    │
│  │  │   PrivateSubnetOne      │     │   PrivateSubnetTwo      │                │    │
│  │  │   (10.0.100.0/24)       │     │   (10.0.101.0/24)       │                │    │
│  │  │   AZ-1                  │     │   AZ-2                  │                │    │
│  │  │                         │     │                         │                │    │
│  │  │ ┌─────────────────────┐ │     │ ┌─────────────────────┐ │                │    │
│  │  │ │    ECS Tasks        │ │     │ │    ECS Tasks        │ │                │    │
│  │  │ │  ┌───────────────┐  │ │     │ │  ┌───────────────┐  │ │                │    │
│  │  │ │  │  webapp:80    │  │ │     │ │  │  webapp:80    │  │ │                │    │
│  │  │ │  │  (Container)  │  │ │     │ │  │  (Container)  │  │ │                │    │
│  │  │ │  └───────────────┘  │ │     │ │  └───────────────┘  │ │                │    │
│  │  │ └─────────────────────┘ │     │ └─────────────────────┘ │                │    │
│  │  └─────────────────────────┘     └─────────────────────────┘                │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

## Infrastructure Components

### 🌐 **Network Layer**
```
VPC (10.0.0.0/16)
├── Public Subnets (Internet Access)
│   ├── PublicSubnetOne (10.0.0.0/24) - AZ-1
│   └── PublicSubnetTwo (10.0.1.0/24) - AZ-2
├── Private Subnets (ECS Tasks)
│   ├── PrivateSubnetOne (10.0.100.0/24) - AZ-1
│   └── PrivateSubnetTwo (10.0.101.0/24) - AZ-2
├── Internet Gateway (Public Internet Access)
├── NAT Gateway (Outbound Internet for Private Subnets)
└── Route Tables (Traffic Routing)
```

### ⚖️ **Load Balancing Layer**
```
Application Load Balancer (alb-devops-workshop)
├── Listener :80 (Production Traffic)
│   └── Routes to: ecs-devops-webapp-TG
├── Listener :8080 (Test Traffic)  
│   └── Routes to: ecs-devops-webapp-TG-tmp
└── Security Group (Allow HTTP from Internet)
```

### 🐳 **Container Platform**
```
ECS Cluster (ecs-devops-workshop)
├── Task Definition (webapp-devops-workshop)
│   ├── CPU: 256 units
│   ├── Memory: 512 MB
│   ├── Network Mode: awsvpc
│   └── Container: webapp:80
├── ECS Service
│   ├── Desired Count: 2 tasks
│   ├── Launch Type: Fargate
│   ├── Deployment: CODE_DEPLOY (Blue/Green)
│   └── Health Check Grace Period: 60s
└── Tasks Distribution
    ├── Task 1 → PrivateSubnetOne
    └── Task 2 → PrivateSubnetTwo
```

### 🔐 **Security Layer**
```
Security Groups
├── PublicLoadBalancerSG
│   └── Allows: All traffic from Internet (0.0.0.0/0)
├── ContainerSecurityGroup  
│   ├── Allows: All traffic from ALB Security Group
│   └── Allows: Inter-container communication
└── Network ACLs (Default VPC settings)
```

### 🏛️ **IAM Roles**
```
IAM Roles
├── ECSTaskExecutionRole
│   └── Policies: AmazonECSTaskExecutionRolePolicy
├── TaskRole (Container Runtime)
│   ├── Deny: All IAM actions (security)
│   ├── Allow: SSM Session Manager
│   └── Allow: CloudWatch Logs
├── AWSServiceRoleForECS
└── AWSServiceRoleForElasticLoadBalancing
```

## Data Flow Diagram

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Internet  │───▶│     ALB     │───▶│ Target Group│───▶│ ECS Tasks   │
│   Traffic   │    │   :80/:8080 │    │    Health   │    │  (Fargate)  │
│             │    │             │    │   Checks    │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                           │
                   ┌───────▼───────┐
                   │  Blue/Green   │
                   │  Deployment   │
                   │   Strategy    │
                   └───────────────┘
```

## Resource Specifications

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **VPC** | 10.0.0.0/16 | Isolated network environment |
| **Public Subnets** | 2 subnets across AZs | ALB placement, NAT Gateway |
| **Private Subnets** | 2 subnets across AZs | ECS task placement |
| **ALB** | Internet-facing | Route external traffic to containers |
| **Target Groups** | 2 groups (primary/temp) | Blue/Green deployment support |
| **ECS Cluster** | Fargate launch type | Serverless container hosting |
| **Tasks** | 2 replicas | High availability |
| **Container** | nginx:latest | Web application hosting |

## DevOps Integration Points

### 🔄 **CI/CD Pipeline Integration**
- **ECR Repository**: Container image storage
- **ECS Service**: Blue/Green deployment target
- **Target Groups**: Traffic switching during deployments
- **CodeDeploy**: Orchestrates Blue/Green deployments

### 📊 **Monitoring & Logging**
- **CloudWatch Logs**: Container application logs
- **ALB Access Logs**: Request/response logging
- **Target Group Health**: Application health monitoring
- **ECS Service Metrics**: Task and service performance

This infrastructure provides a production-ready environment for demonstrating modern DevOps practices with containerized applications on AWS.