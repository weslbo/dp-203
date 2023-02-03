@description('Suffix added to all resource name to make them unique.')
param uniqueSuffix string = uniqueString(resourceGroup().id)

@description('Location of the deployment')
param location string = resourceGroup().location

@description('SQL user name')
param sqlUser string

@secure()
@description('Password for SQL User')
param sqlPassword string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using (az ad signed-in-user show --query userPrincipalName)')
param userPrincipalName string

var rdPrefix = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions'
var role = {
  Owner: '${rdPrefix}/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: '${rdPrefix}/b24988ac-6180-42a0-ab88-20f7382dd24c'
  StorageBlobDataReader: '${rdPrefix}/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  StorageBlobDataContributor: '${rdPrefix}/ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  StorageBlobDataOwner: '${rdPrefix}/b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
}
var tenantId = subscription().tenantId

resource deploymentId 'Microsoft.Resources/tags@2019-10-01' = {
  name: 'default'
  properties: {
    tags: {
      DeploymentId: uniqueSuffix
    }
  }
  dependsOn: []
}

resource dataLakeAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'datalake${uniqueSuffix}'
  location: location
  tags: {
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
    largeFileSharesState: 'Disabled'
  }

  resource service 'blobServices' = {
    name: 'default'

    resource filesystem 'containers' = {
      name: 'files'
    }

    resource data 'containers' = {
      name: 'data'
    }
  }
}

resource workspace 'Microsoft.Synapse/workspaces@2019-06-01-preview' = {
  name: 'synapse-${uniqueSuffix}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: 'https://datalake${uniqueSuffix}.dfs.core.windows.net'
      filesystem: 'files'
    }
    sqlAdministratorLogin: sqlUser
    sqlAdministratorLoginPassword: sqlPassword
    managedResourceGroupName: 'm${resourceGroup().name}-synapse'
    workspaceRepositoryConfiguration: {
      accountName: 'weslbo'
      collaborationBranch: 'main'
      repositoryName: 'dp-203'
      rootFolder: '/synapse/'
      type: 'WorkspaceGitHubConfiguration'
    }
  }
  dependsOn: [
    dataLakeAccount
  ]
}

resource workspace_allowAll 'Microsoft.Synapse/workspaces/firewallrules@2019-06-01-preview' = {
  parent: workspace
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource workspace_sqlDatabase 'Microsoft.Synapse/workspaces/sqlPools@2019-06-01-preview' = {
  parent: workspace
  name: 'sqldwh'
  location: location
  sku: {
    name: 'DW100c'
  }
  properties: {
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

resource workspace_sparkPool 'Microsoft.Synapse/workspaces/bigDataPools@2019-06-01-preview' = {
  parent: workspace
  name: 'sparkpool'
  location: location
  properties: {
    nodeCount: 0
    nodeSizeFamily: 'MemoryOptimized'
    nodeSize: 'Small'
    autoScale: {
      enabled: true
      minNodeCount: 3
      maxNodeCount: 4
    }
    autoPause: {
      enabled: true
      delayInMinutes: 15
    }
    sparkVersion: '3.2'
  }
}

resource workspace_adxPool 'Microsoft.Synapse/workspaces/kustoPools@2021-06-01-preview' = {
  parent: workspace
  name: 'adx${uniqueSuffix}'
  location: location
  sku: {
    capacity: 2
    name: 'Storage optimized'
    size: 'Medium'
  }
  properties: {
    enablePurge: false
    enableStreamingIngest: false
    workspaceUID: reference(workspace.id).workspaceUID
  }
}

resource sqlserver 'Microsoft.Sql/servers@2020-02-02-preview' = {
  name: 'sqldb-${uniqueSuffix}'
  location: location
  tags: {
    displayName: 'SqlServer'
  }
  properties: {
    administratorLogin: sqlUser
    administratorLoginPassword: sqlPassword
    version: '12.0'
  }
}

resource sqlserver_AdventureWorksLT 'Microsoft.Sql/servers/databases@2020-02-02-preview' = {
  parent: sqlserver
  name: 'AdventureWorksLT'
  location: location
  tags: {
    displayName: 'Database'
  }
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    sampleName: 'AdventureWorksLT'
  }
}

resource sqlserver_AllowAllClientIps 'Microsoft.Sql/servers/firewallrules@2020-02-02-preview' = {
  parent: sqlserver
  name: 'AllowAllClientIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource eventNs 'Microsoft.EventHub/namespaces@2022-01-01-preview' = {
  name: 'events-${uniqueSuffix}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1
  }
  properties: {
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    zoneRedundant: false
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
    kafkaEnabled: false
  }
}

resource eventNs_RootManageSharedAccessKey 'Microsoft.EventHub/namespaces/AuthorizationRules@2022-01-01-preview' = {
  parent: eventNs
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}

resource eventNs_eventHub 'Microsoft.EventHub/namespaces/eventhubs@2022-01-01-preview' = {
  parent: eventNs
  name: 'eventhub${uniqueSuffix}'
  properties: {
    messageRetentionInDays: 1
    partitionCount: 2
    status: 'Active'
  }
}

resource eventNs_networkRuleSet 'Microsoft.EventHub/namespaces/networkRuleSets@2022-01-01-preview' = {
  parent: eventNs
  name: 'default'
  properties: {
    publicNetworkAccess: 'Enabled'
    defaultAction: 'Allow'
    virtualNetworkRules: []
    ipRules: []
  }
}

resource eventNs_eventHub_consumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2022-01-01-preview' = {
  parent: eventNs_eventHub
  name: '$Default'
  properties: {
  }
}

resource purviewAccount 'Microsoft.Purview/accounts@2021-07-01' = {
  name: 'purview-${uniqueSuffix}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedResourceGroupName: 'm${resourceGroup().name}-purview'
    publicNetworkAccess: 'Enabled'
  }
}

resource logicapp_pause_resources 'Microsoft.Logic/workflows@2017-07-01' = {
  name: 'logicapp-pause-resources'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    workspace_sqlDatabase
    workspace_adxPool
  ]
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/schemas/2016-06-01/Microsoft.Logic.json'
      contentVersion: '1.0.0.0'
      parameters: {
        '$suspendsqldwhuri': {
          type: 'String'
        }
        '$getdetailssqldwhuri': {
          type: 'String'
        }
        '$suspendadxuri': {
          type: 'String'
        }
        '$getdetailsadxuri': {
          type: 'String'
        }
      }
      triggers: {
        Every2Hours: {
          recurrence: {
            frequency: 'Week'
            interval: 1
            schedule: {
              hours: [
                '0', '2', '4', '6', '8', '10', '12', '14', '16', '18', '20', '22'
              ]
              minutes: [
                0
              ]
              weekDays: [
                'Monday'
                'Tuesday'
                'Wednesday'
                'Thursday'
                'Friday'
              ]
            }
            timeZone: 'Romance Standard Time'
          }
          type: 'Recurrence'
        }
      }
      actions: {
        Condition_ADX: {
          actions: {
            SuspendADX: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  type: 'ManagedServiceIdentity'
                }
                method: 'POST'
                uri: '@parameters(\'$suspendadxuri\')'
              }
            }
          }
          runAfter: {
            Parse_JSON_ADX: [
              'Succeeded'
            ]
          }
          expression: {
            and: [
              {
                not: {
                  equals: [
                    '@body(\'Parse_JSON_ADX\')?[\'properties\']?[\'state\']'
                    'Stopped'
                  ]
                }
              }
            ]
          }
          type: 'If'
        }
        Condition_DWH: {
          actions: {
            SuspendDWH: {
              runAfter: {}
              type: 'Http'
              inputs: {
                authentication: {
                  type: 'ManagedServiceIdentity'
                }
                method: 'POST'
                uri: '@parameters(\'$suspendsqldwhuri\')'
              }
            }
          }
          runAfter: {
            Parse_JSON_DWH: [
              'Succeeded'
            ]
          }
          expression: {
            and: [
              {
                not: {
                  equals: [
                    '@body(\'Parse_JSON_DWH\')?[\'properties\']?[\'status\']'
                    'Paused'
                  ]
                }
              }
            ]
          }
          type: 'If'
        }
        Get_SynapseDedicatedPoolState: {
          runAfter: {}
          type: 'Http'
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: '@parameters(\'$getdetailssqldwhuri\')'
          }
        }
        Get_SynapseDataExplorerState: {
          runAfter: {}
          type: 'Http'
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: '@parameters(\'$getdetailsadxuri\')'
          }
        }
        Parse_JSON_ADX: {
          runAfter: {
            Get_SynapseDataExplorerState: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'Get_SynapseDataExplorerState\')'
            schema: {
              properties: {
                etag: {
                  type: 'string'
                }
                id: {
                  type: 'string'
                }
                location: {
                  type: 'string'
                }
                name: {
                  type: 'string'
                }
                properties: {
                  properties: {
                    dataIngestionUri: {
                      type: 'string'
                    }
                    enablePurge: {
                      type: 'boolean'
                    }
                    enableStreamingIngest: {
                      type: 'boolean'
                    }
                    languageExtensions: {
                      properties: {
                        value: {
                          type: 'array'
                        }
                      }
                      type: 'object'
                    }
                    optimizedAutoscale: {}
                    provisioningState: {
                      type: 'string'
                    }
                    state: {
                      type: 'string'
                    }
                    stateReason: {}
                    uri: {
                      type: 'string'
                    }
                    workspaceUID: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                sku: {
                  properties: {
                    capacity: {
                      type: 'integer'
                    }
                    name: {
                      type: 'string'
                    }
                    size: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                tags: {
                  properties: {}
                  type: 'object'
                }
                type: {
                  type: 'string'
                }
              }
            }
          }
        }
        Parse_JSON_DWH: {
          runAfter: {
            Get_SynapseDedicatedPoolState: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
          inputs: {
            content: '@body(\'Get_SynapseDedicatedPoolState\')'
            schema: {
              properties: {
                id: {
                  type: 'string'
                }
                location: {
                  type: 'string'
                }
                name: {
                  type: 'string'
                }
                properties: {
                  properties: {
                    collation: {
                      type: 'string'
                    }
                    creationDate: {
                      type: 'string'
                    }
                    maxSizeBytes: {
                      type: 'integer'
                    }
                    provisioningState: {
                      type: 'string'
                    }
                    status: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                sku: {
                  properties: {
                    capacity: {
                      type: 'integer'
                    }
                    name: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                type: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      outputs: {
      }
    }
    parameters: {
      '$suspendsqldwhuri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Synapse/workspaces/synapse-${uniqueSuffix}/sqlPools/sqldwh/pause?api-version=2019-06-01-preview'
      }
      '$getdetailssqldwhuri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Synapse/workspaces/synapse-${uniqueSuffix}/sqlPools/sqldwh?api-version=2019-06-01-preview'
      }
      '$suspendadxuri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Synapse/workspaces/synapse-${uniqueSuffix}/kustoPools/adx${uniqueSuffix}/stop?api-version=2021-06-01-preview'
      }
      '$getdetailsadxuri': {
        type: 'String'
        value: 'https://management.azure.com/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Synapse/workspaces/synapse-${uniqueSuffix}/kustoPools/adx${uniqueSuffix}?api-version=2021-06-01-preview'
      }
    }
  }
}

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: 'cosmos-${uniqueSuffix}'
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
      }
    ]
  }
}

var managedResourceGroupNameForDatabricks = 'm${resourceGroup().name}-databricks'
var managedResourceGroupId = concat(subscription().id, '/resourceGroups/', managedResourceGroupNameForDatabricks)

resource managedResourceGroupForDatabricks 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: managedResourceGroupNameForDatabricks
}

resource databricks 'Microsoft.Databricks/workspaces@2022-04-01-preview' = {
  name: 'databricks-${uniqueSuffix}'
  location: location
  sku: {
    name: 'premium'
  }
  properties: {
    managedResourceGroupId: managedResourceGroupId
    parameters: {
      enableNoPublicIp: {
        value: false
      }
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: 'keyvault-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableSoftDelete: false
    tenantId: tenantId
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: workspace.identity.principalId
        permissions:{
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
        }
      }
      {
        tenantId: tenantId
        objectId: purviewAccount.identity.principalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
  resource secret 'secrets' = {
    name: 'sqlpassword'
    properties: {
      value: sqlPassword
    }
  }
}


resource roleassignment_synapse_to_datalake 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('synapse_to_datalake_{resourceGroup().name}')
  scope: dataLakeAccount
  properties: {
    roleDefinitionId: role['StorageBlobDataOwner']
    principalId: workspace.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource rolesassignments_purview_to_datalake 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('purview_to_datalake_${resourceGroup().name}')
  scope: dataLakeAccount
  properties: {
    principalId: purviewAccount.identity.principalId
    roleDefinitionId: role['StorageBlobDataContributor']
    principalType: 'ServicePrincipal'
  }
}

resource rolesassignments_logical_to_resourcegroup 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name:  guid('logicapp_to_resourcegroup_${resourceGroup().name}')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: role['Contributor']
    principalId: logicapp_pause_resources.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// Current user should become a Storage Blob Data Contributor 
resource rolesassignments_currentuser_to_datalake 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('currentuser_to_datalake_${resourceGroup().name}')
  scope: dataLakeAccount
  properties: {
    principalId: userPrincipalName
    roleDefinitionId: role['StorageBlobDataContributor']
    principalType: 'User'
  }
}

output workspaceid string = workspace.properties.workspaceUID

