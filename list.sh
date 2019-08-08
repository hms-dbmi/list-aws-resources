#!/usr/bin/env bash
set -o errexit

die() { set +v; echo "$*" 1>&2 ; exit 1; }

[ "$#" = 0 ] || die 'Expects no arguments'

echo 'S3 Buckets:'
aws s3api list-buckets --output text \
  --query 'Buckets[][CreationDate,Name] | sort_by(@, &[0])'  \
  | perl -pne 's/^/\t/'

echo 'IAM Users:'
aws iam list-users --output text \
  --query 'Users[][CreateDate,UserName] | sort_by(@, &[0])' \
  | perl -pne 's/^/\t/'

echo 'IAM Local Policies:'
aws iam list-policies --scope Local --output text \
  --query 'Policies[][CreateDate,PolicyName] | sort_by(@, &[0])' \
  | perl -pne 's/^/\t/'

echo 'IAM Groups:'
aws iam list-groups --output text \
  --query 'Groups[][CreateDate,GroupName] | sort_by(@, &[0])' \
  | perl -pne 's/^/\t/'

echo 'Route53 Hosted Zones:'
aws route53 list-hosted-zones --output text \
  --query 'HostedZones[][Id,Name]' \
  | perl -pne 's/^/\t/'

echo 'EC2 Instances:'
aws ec2 describe-instances --output text \
  --query 'Reservations[][Instances[][LaunchTime,InstanceType,KeyName,State.Name]] | sort_by(@[][], &[0])' \
  | perl -pne 's/^/\t/'
