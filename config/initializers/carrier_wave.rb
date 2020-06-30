CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      # Configuration for Amazon S3
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_ID'],
      use_iam_profile: true,
      region: 'us-east-1',
      use_iam_profile: false,
    }
    config.fog_directory     = ENV['S3_BUCKET']
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
