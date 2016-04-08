# elb-logging

# Problem Domain
The manual process: http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/enable-access-logs.html

# Examples
ruby elb-logging-enable.rb --elb_name {NAME} --app {app name}

S3 bucket will be created with this syntax- bucket_name = :elb_name + "-logging"
emit_interval: 5 minutes 
Need to change the principal aws id; refer to http://docs.aws.amazon.com/AmazonS3/latest/dev/s3-bucket-user-policy-specifying-principal-intro.html

Default policy in use in this script:

```ruby
  "Id" => "Policy1459871218139",
  "Version" => "2012-10-17",
  "Statement" => [
    {
      "Sid" => "Stmt1459871212751",
      "Action" => ["s3:PutObject"],
      "Effect" => "Allow",
      "Resource" => resource_name,
      "Principal" => {
        "AWS" => [
          "127311923021"
        ]
      }
    }
  ]
}
