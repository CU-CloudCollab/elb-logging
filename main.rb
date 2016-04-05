require 'aws-sdk'
require 'json'
require 'optparse'


# -r = region, -t name:value, -op operation (start/stop)
OPTIONS = {}

#Default Values

OptionParser.new do |opt|
  opt.on('--elb_name elb name') { |o| OPTIONS[:elb_name] = o }
  opt.on('--app app name') { |o| OPTIONS[:app_name] = o }
end.parse!

bucket_name = OPTIONS[:elb_name] + "-logging"
resource_name = "arn:aws:s3:::" + bucket_name +  "/" + OPTIONS[:app_name] + "/*"

s3 = Aws::S3::Client.new(region: 'us-east-1')
new_bucket = s3.create_bucket(bucket: bucket_name)

policy_json = {
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

s3.put_bucket_policy({
  bucket: bucket_name,
  policy: policy_json.to_json
})

elb_client = Aws::ElasticLoadBalancing::Client.new(
  region: 'us-east-1'
)
resp = elb_client.modify_load_balancer_attributes({
  load_balancer_name: OPTIONS[:elb_name], # required
  load_balancer_attributes: {
    access_log: {
      enabled: true, # required
      s3_bucket_name: bucket_name,
      emit_interval: 5,
      s3_bucket_prefix: OPTIONS[:app_name],
    }
  },
})

objects_created = s3.list_objects(bucket: bucket_name).contents.length

exit objects_created==1 ? 0 : 1