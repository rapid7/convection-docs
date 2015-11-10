require 'convection'

module Templates
  JUMP_HOSTS = Convection.template do
    description 'Deploy SSH jump hosts'

    # parameter 'JumpHostInstanceType' do
    #   type 'String'
    #   description 'EC2 Instance Type'
    #   default 'm3.medium'
    # end

    mapping 'JumpHostImage' do
      item 'us-east-1', 'hvm', 'ami-xxxxxxxx'
      item 'eu-central-1', 'hvm', 'ami-yyyyyyyy'
      item 'us-west-1', 'hvm', 'ami-df6a8b9b'
    end

    mapping 'JumpHostKeyName' do
      item 'us-east-1', 'key', 'somekey'
      item 'eu-central-1', 'key', 'anotherkey'
      item 'us-west-1', 'key', 'cf-test-keys'
    end

    ec2_instance 'JumpHost0' do
      image_id find_in_map('JumpHostImage', stack.region, 'hvm')
      instance_type stack['InstanceType']
      key_name find_in_map('JumpHostKeyName', stack.region, 'key')
      subnet stack.get('vpc', 'JumpHost')
      security_group stack.get('security-groups', 'JumpHost')

      tag 'Name', 'jumphost-0'
      tag 'Service', 'JumpHost'
      tag 'Stack', stack.cloud
    end

    route53_recordset 'JumpHostDNS' do
      zone 'Z3TZ11VMO4E2R5'
      record_name "ssh.#{stack.cloud}.#{stack.region}.razortest.com."
      record_type 'CNAME'
      # record get_att('JumpHost0', 'PublicDnsName')
      record get_att('JumpHost0', 'PrivateDnsName')
      ttl 30
    end
  end
end
