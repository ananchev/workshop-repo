# Cleanup

This section covers removing all AWS resources created during the workshop to avoid ongoing charges.

## Important Notes

- **Order matters**: Delete resources in the specified sequence to avoid dependency conflicts
- **Verification**: Confirm each deletion before proceeding to the next step
- **CloudFormation**: Some deletions may take several minutes to complete

## Pipeline Cleanup

### Delete CodePipeline

1. Go to [AWS CodePipeline Console](https://console.aws.amazon.com/codesuite/codepipeline/)
2. Select `MyFirstPipeline`
3. Click **Delete pipeline** (top right)
4. Type `delete` to confirm
5. Enable checkbox: **No resource updates needed for this source action change**
6. Click **Delete**

### Delete CodeDeploy Application

1. Go to [AWS CodeDeploy Console](https://console.aws.amazon.com/codesuite/codedeploy/)
2. Click on `devops-workshop-MyWebApp`
3. Click **Delete application** (right side)
4. Type `delete` to confirm
5. Click **Delete**

### Delete CodeBuild Project

1. Go to [AWS CodeBuild Console](https://console.aws.amazon.com/codesuite/codebuild/)
2. Select `MyFirstBuild`
3. Click **Delete build project** (top right)
4. Type `delete` to confirm
5. Click **Delete**

## IAM Resources Cleanup

### Delete IAM Policies

1. Go to [IAM Console](https://console.aws.amazon.com/iam/)
2. Click **Policies** in left navigation
3. In Filter field, type `MyFirst`
4. For each policy found:
   - Select the policy
   - Click **Actions** → **Delete**
   - Type the policy name to confirm
   - Click **Delete**

### Delete CloudFormation Stack (IAM Roles)

1. Go to [AWS CloudFormation Console](https://console.aws.amazon.com/cloudformation/)
2. Select `DevopsWorkshop-roles` stack
3. Click **Delete** (top right)
4. Confirm deletion by clicking **Delete stack**
5. Monitor progress until deletion completes

### Delete Service Roles (if needed)

Check for any remaining service roles:

```bash
cat /tmp/roles_created.txt
```

For each role listed:
1. Go to IAM Console → **Roles**
2. Filter by role name
3. Select the role
4. Click **Delete** (top right)
5. Type role name to confirm deletion

**Note**: If you encounter errors, some roles might be in use by other services in your account - you can skip these.

## Infrastructure Cleanup

### Run Cleanup Script

Execute the automated cleanup script:

```bash
cd /Workshop/setup
chmod +x clean.sh
./clean.sh
```

This script will remove:
- ECS cluster and services
- Application Load Balancer and target groups  
- ECR repository and container images
- VPC and networking components
- Security groups and NAT Gateway
- CloudFormation stacks

### Monitor CloudFormation Deletion

1. Go to CloudFormation Console
2. Monitor `devops-cluster` stack deletion progress
3. Check **Events** tab for detailed progress
4. Wait for `DELETE_COMPLETE` status
5. Stack will disappear from list when fully deleted

## Manual Verification

### Confirm Resource Deletion

**ECS Resources:**
- No ECS clusters named `ecs-devops-workshop`
- No ECS services or task definitions remaining

**Networking:**
- VPC `devops-cluster` removed
- Associated subnets, route tables, and gateways deleted

**Storage:**
- ECR repository `devops-workshop-app` deleted
- All container images removed

**Load Balancing:**
- Application Load Balancer `alb-devops-workshop` deleted
- Target groups removed

### Check for Remaining Resources

**CloudWatch Logs:**
- Log groups may persist (minimal cost)
- Can be deleted manually if desired

**IAM:**
- Verify no workshop-related policies or roles remain
- AWS-managed roles are safe to leave

## Cost Verification

### Final Cost Check

After cleanup completion:
- All billable resources should be removed
- Workshop used only AWS Free Tier eligible resources
- No ongoing charges should remain

### AWS Cost Explorer

Optionally verify in AWS Cost Explorer:
- Check ECS, ECR, and EC2 usage
- Confirm no unexpected charges
- Monitor for 24-48 hours to ensure cleanup was complete

## Cleanup Confirmation

### Successful Cleanup Indicators

✅ **CodePipeline**: No pipelines in console  
✅ **CodeBuild**: No build projects remaining  
✅ **CodeDeploy**: No applications in console  
✅ **ECS**: No clusters or services  
✅ **ECR**: Repository deleted  
✅ **CloudFormation**: All workshop stacks removed  
✅ **IAM**: No workshop-specific policies or roles  
✅ **VPC**: Workshop VPC and components deleted  

### Environment Status

Your AWS environment should now be restored to pre-workshop state:
- No ongoing charges from workshop resources
- Default VPC and security groups unchanged
- IAM permissions returned to original state
- All workshop-specific configurations removed

## Troubleshooting Cleanup Issues

### CloudFormation Deletion Stuck

If CloudFormation deletion fails:
1. Check **Events** tab for specific error details
2. Manually delete blocking resources if identified
3. Retry stack deletion
4. Contact AWS Support if issues persist

### IAM Role Deletion Errors

If roles cannot be deleted:
- Check if roles are attached to running services
- Verify no policies are attached
- Some AWS-managed roles cannot be deleted (this is normal)

### Network Resource Dependencies

If VPC deletion fails:
- Ensure all EC2 instances are terminated
- Check for remaining ENIs or security group references
- Delete dependent resources before retrying VPC deletion

## Summary

You have successfully cleaned up all AWS resources created during the DevOps workshop. Your environment is now restored to its original state with no ongoing costs from the workshop resources.

## What You Accomplished

Throughout this workshop, you learned to:
- ✅ Set up AWS DevOps services and tools
- ✅ Create GitHub integration with AWS CodeConnection
- ✅ Configure Docker containers and build specifications
- ✅ Implement Blue/Green deployment strategies
- ✅ Build complete CI/CD pipelines with CodePipeline
- ✅ Test automated deployments with zero downtime
- ✅ Monitor and troubleshoot pipeline executions
- ✅ Clean up resources properly to avoid costs

The knowledge and configuration files in this repository serve as your reference for future DevOps implementations using AWS services.