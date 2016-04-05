require 'aws-sdk'
#require 'pp'
require 'json'

s3 = Aws::S3::Client.new(region: 'us-east-1')
new_bucket = s3.create_bucket(bucket: 'team1-elb-logging-s3')
s3.put_object(bucket: 'team1-elb-logging-s3', key: "my-app/AWSLogs/101334791012/")

policy_json = {
  "Id" => "Policy1459871218139",
  "Version" => "2012-10-17",
  "Statement" => [
    {
      "Sid" => "Stmt1459871212751",
      "Action" => [
        "s3:PutObject"
      ],
      "Effect" => "Allow",
      "Resource" => "arn:aws:s3:::team1-elb-logging-s3/my-app/AWSLogs/101334791012",
      "Principal" => {
        "AWS" => [
          "127311923021"
        ]
      }
    }
  ]
}

s3.put_bucket_policy({
  bucket: "team1-elb-logging-s3",
  policy: policy_json.to_json
})

elb_client = Aws::ElasticLoadBalancing::Client.new(
  region: 'us-east-1'
)
resp = elb_client.modify_load_balancer_attributes({
  load_balancer_name: "team1-elb", # required
  load_balancer_attributes: { 
    access_log: {
      enabled: true, # required
      s3_bucket_name: "team1-elb-logging-s3",
      emit_interval: 5,
      s3_bucket_prefix: "my-app",
    }
  },
})