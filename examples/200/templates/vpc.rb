require 'convection'

module Templates
  VPC = Convection.template do
    description 'A demo VPC'

    parameter 'UniqueID' do
      description 'Lie to CF'
      default 'E60E5082-ACD1-490C-B734-F2582E95DB80'
    end

    ec2_vpc 'Demo' do
      network stack['subnet']

      tag 'Name', stack.cloud
      tag 'Stack', stack.cloud
      tag 'UniqueID', fn_ref('UniqueID')

      with_output 'id'
    end

    ec2_subnet 'JumpHost' do
      vpc fn_ref('Demo')
      availability_zone "#{ stack.region }a"
      # as_attribute 'JumpHostSubnets', :array
      with_output

      network '192.168.0.0/24'

      property('MapPublicIpOnLaunch', true)

      immutable_metadata "JumpHost-#{ stack.cloud }" ## Asgard
      tag 'Name', "subnet-JumpHost-#{ stack.cloud }-#{ stack.region }a"
      tag 'Stack', stack.cloud
    end
  end
end
