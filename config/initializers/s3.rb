# frozen_string_literal: true

require 'aws-sdk-core'

Aws.config.update(
  region: ENV.fetch('AWS_REGION', nil),
  credentials: Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID', nil), ENV.fetch('AWS_SECRET_ACCESS_KEY', nil))
)
