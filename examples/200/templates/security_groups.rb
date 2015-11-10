require 'convection'

module Templates
  SECURITY_GROUPS = Convection.template do
    description 'Demo Security Groups'

    ec2_security_group 'JumpHost' do
      vpc stack.get('vpc', 'id')
      description 'JumpHost Instances'

      ingress_rule(:tcp, 22, '0.0.0.0/0')

      tag 'Name', "sg-#{ name.downcase }-#{ stack.cloud }"
      tag 'Service', name
      tag 'Resource', 'Instance'
      tag 'Stack', stack.cloud

      with_output
    end
  end
end
