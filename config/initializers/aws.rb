# frozen_string_literal: true

Aws.config[:credentials] = Aws::Credentials.new(
  ENV.fetch('BUCKETEER_AWS_ACCESS_KEY_ID', nil),
  ENV.fetch('BUCKETEER_AWS_SECRET_ACCESS_KEY', nil)
)
Aws.config[:region] = 'us-west-1'

S3 = Aws::S3::Client.new
