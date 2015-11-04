def ramdom_data(mail_address)
    sample_data = {
     distributorFlag: 0,
     mail: mail_address,
     password: 'YOUR_PASSWORD',
     portalUse: 1
    }
end

def ramdom_nam
  SecureRandom.uuid
end

def ramdom_group_name_data
  suffix = SecureRandom.uuid
  group_name = 'dev_'.concat(suffix)
  group_data = {
  groupName: group_name
  }
end

def get_role_data
    role_data = {resources: [
      {
        basePath: "/v1/business-process",
        ipAddress: "*",
        path: "*",
        verb: "*"
      },
      {
        basePath: "/v1/apilog",
        ipAddress: "153.142.2.18/32",
        path: "*",
        verb: "*"
      },
      {
        basePath: "/v1/cloudn",
        ipAddress: "*",
        path: "*",
        verb: "*"
      }
     ],
    roleName: "sample-role1"
    }
end
