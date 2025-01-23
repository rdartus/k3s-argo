{{- define "helmValues.redis"}} 

# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

## @section Global parameters
## Global Docker image parameters
## Please, note that this will override the image parameters, including dependencies, configured to use the global value
## Current available global Docker image parameters: imageRegistry, imagePullSecrets and storageClass
##

## @param global.imageRegistry Global Docker image registry
## @param global.imagePullSecrets Global Docker registry secret names as an array
## @param global.defaultStorageClass Global default StorageClass for Persistent Volume(s)
## @param global.storageClass DEPRECATED: use global.defaultStorageClass instead
## @param global.redis.password Global Redis&reg; password (overrides `auth.password`)
##
global:
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  defaultStorageClass: ""
  storageClass: ""
  # redis:
  #   password: "testredis"

## @section Common parameters
##

## @param kubeVersion Override Kubernetes version
##
kubeVersion: ""
## @param nameOverride String to partially override common.names.fullname
##
nameOverride: ""
## @param fullnameOverride String to fully override common.names.fullname
##
fullnameOverride: ""
## @param namespaceOverride String to fully override common.names.namespace
##
namespaceOverride: ""
## @param commonLabels Labels to add to all deployed objects
##
commonLabels: {}
## @param commonAnnotations Annotations to add to all deployed objects
##
commonAnnotations: {}
## @param secretAnnotations Annotations to add to secret
##
secretAnnotations: {}
## @param clusterDomain Kubernetes cluster domain name
##
clusterDomain: cluster.local
## @param extraDeploy Array of extra objects to deploy with the release
##
extraDeploy: []
## @param useHostnames Use hostnames internally when announcing replication. If false, the hostname will be resolved to an IP address
##
useHostnames: true
## @param nameResolutionThreshold Failure threshold for internal hostnames resolution
##
nameResolutionThreshold: 5
## @param nameResolutionTimeout Timeout seconds between probes for internal hostnames resolution
##
nameResolutionTimeout: 5
## Enable diagnostic mode in the deployment
##
diagnosticMode:
  ## @param diagnosticMode.enabled Enable diagnostic mode (all probes will be disabled and the command will be overridden)
  ##
  enabled: false
  ## @param diagnosticMode.command Command to override all containers in the deployment
  ##
  command:
    - sleep
  ## @param diagnosticMode.args Args to override all containers in the deployment
  ##
  args:
    - infinity
## @section Redis&reg; Image parameters
##

## Bitnami Redis&reg; image
## ref: https://hub.docker.com/r/bitnami/redis/tags/
## @param image.registry [default: REGISTRY_NAME] Redis&reg; image registry
## @param image.repository [default: REPOSITORY_NAME/redis] Redis&reg; image repository
## @skip image.tag Redis&reg; image tag (immutable tags are recommended)
## @param image.digest Redis&reg; image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
## @param image.pullPolicy Redis&reg; image pull policy
## @param image.pullSecrets Redis&reg; image pull secrets
## @param image.debug Enable image debug mode
##
image:
  registry: docker.io
  repository: bitnami/redis
  tag: 7.4.2-debian-12-r0
  digest: ""
  ## Specify a imagePullPolicy
  ## ref: https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images
  ##
  pullPolicy: IfNotPresent
  ## Optionally specify an array of imagePullSecrets.
  ## Secrets must be manually created in the namespace.
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
  ## e.g:
  ## pullSecrets:
  ##   - myRegistryKeySecretName
  ##
  pullSecrets: []
  ## Enable debug mode
  ##
  debug: false
## @section Redis&reg; common configuration parameters
## https://github.com/bitnami/containers/tree/main/bitnami/redis#configuration
##

## @param architecture Redis&reg; architecture. Allowed values: `standalone` or `replication`
##
architecture: replication
## Redis&reg; Authentication parameters
## ref: https://github.com/bitnami/containers/tree/main/bitnami/redis#setting-the-server-password-on-first-run
##
auth:
  ## @param auth.enabled Enable password authentication
  ##
  enabled: true
  ## @param auth.sentinel Enable password authentication on sentinels too
  ##
  sentinel: true
  ## @param auth.password Redis&reg; password
  ## Defaults to a random 10-character alphanumeric string if not set
  ##
  password: ""
  ## @param auth.existingSecret The name of an existing secret with Redis&reg; credentials
  ## NOTE: When it's set, the previous `auth.password` parameter is ignored
  ##
  existingSecret: "redis-secret"
  ## @param auth.existingSecretPasswordKey Password key to be retrieved from existing secret
  ## NOTE: ignored unless `auth.existingSecret` parameter is set
  ##
  existingSecretPasswordKey: "password"
  ## @param auth.usePasswordFiles Mount credentials as files instead of using an environment variable
  ##
  usePasswordFiles: false

## @param commonConfiguration [string] Common configuration to be added into the ConfigMap
## ref: https://redis.io/topics/config
##
commonConfiguration: |-
  # Enable AOF https://redis.io/topics/persistence#append-only-file
  appendonly no
  # Disable RDB persistence, AOF persistence already enabled.
  save ""
## @param existingConfigmap The name of an existing ConfigMap with your custom configuration for Redis&reg; nodes
##
existingConfigmap: ""
## @section Redis&reg; master configuration parameters
##
master:
  ## @param master.count Number of Redis&reg; master instances to deploy (experimental, requires additional configuration)
  ##
  count: 1
  ## @param master.revisionHistoryLimit The number of old history to retain to allow rollback
  ## NOTE: Explicitly setting this field to 0, will result in cleaning up all the history, breaking ability to rollback
  revisionHistoryLimit: 10
  ## @param master.configuration Configuration for Redis&reg; master nodes
  ## ref: https://redis.io/topics/config
  ##
  configuration: ""
  ## @param master.disableCommands Array with Redis&reg; commands to disable on master nodes
  ## Commands will be completely disabled by renaming each to an empty string.
  ## ref: https://redis.io/topics/security#disabling-of-specific-commands
  ##
  disableCommands:
    - FLUSHDB
    - FLUSHALL
  ## @param master.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param master.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param master.enableServiceLinks Whether information about services should be injected into pod's environment variable
  ##
  enableServiceLinks: true
  ## @param master.preExecCmds Additional commands to run prior to starting Redis&reg; master
  ##
  preExecCmds: []
  ## @param master.extraFlags Array with additional command line flags for Redis&reg; master
  ## e.g:
  ## extraFlags:
  ##  - "--maxmemory-policy volatile-ttl"
  ##  - "--repl-backlog-size 1024mb"
  ##
  extraFlags: []
  ## @param master.extraEnvVars Array with extra environment variables to add to Redis&reg; master nodes
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## @param master.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for Redis&reg; master nodes
  ##
  extraEnvVarsCM: ""
  ## @param master.extraEnvVarsSecret Name of existing Secret containing extra env vars for Redis&reg; master nodes
  ##
  extraEnvVarsSecret: ""
  ## @param master.containerPorts.redis Container port to open on Redis&reg; master nodes
  ##
  containerPorts:
    redis: 6379
  ## Configure extra options for Redis&reg; containers' liveness and readiness probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param master.startupProbe.enabled Enable startupProbe on Redis&reg; master nodes
  ## @param master.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param master.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param master.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param master.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param master.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param master.livenessProbe.enabled Enable livenessProbe on Redis&reg; master nodes
  ## @param master.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param master.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param master.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param master.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param master.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param master.readinessProbe.enabled Enable readinessProbe on Redis&reg; master nodes
  ## @param master.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param master.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param master.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param master.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param master.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 5
  ## @param master.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param master.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param master.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## Redis&reg; master resource requests and limits
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ## @param master.resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production).
  ## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
  ##
  resourcesPreset: "nano"
  ## @param master.resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
  ## Example:
  ## resources:
  ##   requests:
  ##     cpu: 2
  ##     memory: 512Mi
  ##   limits:
  ##     cpu: 3
  ##     memory: 1024Mi
  ##
  resources: {}
  ## Configure Pods Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param master.podSecurityContext.enabled Enabled Redis&reg; master pods' Security Context
  ## @param master.podSecurityContext.fsGroupChangePolicy Set filesystem group change policy
  ## @param master.podSecurityContext.sysctls Set kernel settings using the sysctl interface
  ## @param master.podSecurityContext.supplementalGroups Set filesystem extra groups
  ## @param master.podSecurityContext.fsGroup Set Redis&reg; master pod's Security Context fsGroup
  ##
  podSecurityContext:
    enabled: true
    fsGroupChangePolicy: Always
    sysctls: []
    supplementalGroups: []
    fsGroup: 1001
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param master.containerSecurityContext.enabled Enabled Redis&reg; master containers' Security Context
  ## @param master.containerSecurityContext.seLinuxOptions [object,nullable] Set SELinux options in container
  ## @param master.containerSecurityContext.runAsUser Set Redis&reg; master containers' Security Context runAsUser
  ## @param master.containerSecurityContext.runAsGroup Set Redis&reg; master containers' Security Context runAsGroup
  ## @param master.containerSecurityContext.runAsNonRoot Set Redis&reg; master containers' Security Context runAsNonRoot
  ## @param master.containerSecurityContext.allowPrivilegeEscalation Is it possible to escalate Redis&reg; pod(s) privileges
  ## @param master.containerSecurityContext.readOnlyRootFilesystem Set container's Security Context read-only root filesystem
  ## @param master.containerSecurityContext.seccompProfile.type Set Redis&reg; master containers' Security Context seccompProfile
  ## @param master.containerSecurityContext.capabilities.drop Set Redis&reg; master containers' Security Context capabilities to drop
  ##
  containerSecurityContext:
    enabled: true
    seLinuxOptions: {}
    runAsUser: 1001
    runAsGroup: 1001
    runAsNonRoot: true
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    seccompProfile:
      type: RuntimeDefault
    capabilities:
      drop: ["ALL"]
  ## @param master.kind Use either Deployment, StatefulSet (default) or DaemonSet
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
  ##
  kind: StatefulSet
  ## @param master.schedulerName Alternate scheduler for Redis&reg; master pods
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param master.updateStrategy.type Redis&reg; master statefulset strategy type
  ## @skip master.updateStrategy.rollingUpdate
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy:
    ## StrategyType
    ## Can be set to RollingUpdate, OnDelete (statefulset), Recreate (deployment)
    ##
    type: RollingUpdate
  ## @param master.minReadySeconds How many seconds a pod needs to be ready before killing the next, during update
  ##
  minReadySeconds: 0
  ## @param master.priorityClassName Redis&reg; master pods' priorityClassName
  ##
  priorityClassName: ""
  ## @param master.automountServiceAccountToken Mount Service Account token in pod
  ##
  automountServiceAccountToken: false
  ## @param master.hostAliases Redis&reg; master pods host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param master.podLabels Extra labels for Redis&reg; master pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  ##
  podLabels: {}
  ## @param master.podAnnotations Annotations for Redis&reg; master pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param master.shareProcessNamespace Share a single process namespace between all of the containers in Redis&reg; master pods
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/
  ##
  shareProcessNamespace: false
  ## @param master.podAffinityPreset Pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param master.podAntiAffinityPreset Pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## Node master.affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param master.nodeAffinityPreset.type Node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param master.nodeAffinityPreset.key Node label key to match. Ignored if `master.affinity` is set
    ##
    key: ""
    ## @param master.nodeAffinityPreset.values Node label values to match. Ignored if `master.affinity` is set
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param master.affinity Affinity for Redis&reg; master pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## NOTE: `master.podAffinityPreset`, `master.podAntiAffinityPreset`, and `master.nodeAffinityPreset` will be ignored when it's set
  ##
  affinity: {}
  ## @param master.nodeSelector Node labels for Redis&reg; master pods assignment
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
  ##
  nodeSelector: {}
  ## @param master.tolerations Tolerations for Redis&reg; master pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param master.topologySpreadConstraints Spread Constraints for Redis&reg; master pod assignment
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ## E.g.
  ## topologySpreadConstraints:
  ##   - maxSkew: 1
  ##     topologyKey: node
  ##     whenUnsatisfiable: DoNotSchedule
  ##
  topologySpreadConstraints: []
  ## @param master.dnsPolicy DNS Policy for Redis&reg; master pod
  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
  ## E.g.
  ## dnsPolicy: ClusterFirst
  ##
  dnsPolicy: ""
  ## @param master.dnsConfig DNS Configuration for Redis&reg; master pod
  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
  ## E.g.
  ## dnsConfig:
  ##   options:
  ##   - name: ndots
  ##     value: "4"
  ##   - name: single-request-reopen
  ##
  dnsConfig: {}
  ## @param master.lifecycleHooks for the Redis&reg; master container(s) to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## @param master.extraVolumes Optionally specify extra list of additional volumes for the Redis&reg; master pod(s)
  ##
  extraVolumes: []
  ## @param master.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the Redis&reg; master container(s)
  ##
  extraVolumeMounts: []
  ## @param master.sidecars Add additional sidecar containers to the Redis&reg; master pod(s)
  ## e.g:
  ## sidecars:
  ##   - name: your-image-name
  ##     image: your-image
  ##     imagePullPolicy: Always
  ##     ports:
  ##       - name: portname
  ##         containerPort: 1234
  ##
  sidecars: []
  ## @param master.initContainers Add additional init containers to the Redis&reg; master pod(s)
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
  ## e.g:
  ## initContainers:
  ##  - name: your-image-name
  ##    image: your-image
  ##    imagePullPolicy: Always
  ##    command: ['sh', '-c', 'echo "hello world"']
  ##
  initContainers: []
  ## Persistence parameters
  ## ref: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
  ##
  persistence:
    ## @param master.persistence.enabled Enable persistence on Redis&reg; master nodes using Persistent Volume Claims
    ##
    enabled: true
    ## @param master.persistence.medium Provide a medium for `emptyDir` volumes.
    ##
    medium: ""
    ## @param master.persistence.sizeLimit Set this to enable a size limit for `emptyDir` volumes.
    ##
    sizeLimit: ""
    ## @param master.persistence.path The path the volume will be mounted at on Redis&reg; master containers
    ## NOTE: Useful when using different Redis&reg; images
    ##
    path: /data
    ## @param master.persistence.subPath The subdirectory of the volume to mount on Redis&reg; master containers
    ## NOTE: Useful in dev environments
    ##
    subPath: ""
    ## @param master.persistence.subPathExpr Used to construct the subPath subdirectory of the volume to mount on Redis&reg; master containers
    ##
    subPathExpr: ""
    ## @param master.persistence.storageClass Persistent Volume storage class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner
    ##
    storageClass: ""
    ## @param master.persistence.accessModes Persistent Volume access modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param master.persistence.size Persistent Volume size
    ##
    size: 1Gi
    ## @param master.persistence.annotations Additional custom annotations for the PVC
    ##
    annotations: {}
    ## @param master.persistence.labels Additional custom labels for the PVC
    ##
    labels: {}
    ## @param master.persistence.selector Additional labels to match for the PVC
    ## e.g:
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
    ## @param master.persistence.dataSource Custom PVC data source
    ##
    dataSource: {}
    ## @param master.persistence.existingClaim Use a existing PVC which must be created manually before bound
    ## NOTE: requires master.persistence.enabled: true
    ##
    existingClaim: ""
  ## persistentVolumeClaimRetentionPolicy
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#persistentvolumeclaim-retention
  ## @param master.persistentVolumeClaimRetentionPolicy.enabled Controls if and how PVCs are deleted during the lifecycle of a StatefulSet
  ## @param master.persistentVolumeClaimRetentionPolicy.whenScaled Volume retention behavior when the replica count of the StatefulSet is reduced
  ## @param master.persistentVolumeClaimRetentionPolicy.whenDeleted Volume retention behavior that applies when the StatefulSet is deleted
  ##
  persistentVolumeClaimRetentionPolicy:
    enabled: false
    whenScaled: Retain
    whenDeleted: Retain
  ## Redis&reg; master service parameters
  ##
  service:
    ## @param master.service.type Redis&reg; master service type
    ##
    type: ClusterIP
    ## @param master.service.portNames.redis Redis&reg; master service port name
    ##
    portNames:
      redis: "tcp-redis"
    ## @param master.service.ports.redis Redis&reg; master service port
    ##
    ports:
      redis: 6379
    ## @param master.service.nodePorts.redis Node port for Redis&reg; master
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ## NOTE: choose port between <30000-32767>
    ##
    nodePorts:
      redis: ""
    ## @param master.service.externalTrafficPolicy Redis&reg; master service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param master.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param master.service.internalTrafficPolicy Redis&reg; master service internal traffic policy (requires Kubernetes v1.22 or greater to be usable)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service-traffic-policy/
    ##
    internalTrafficPolicy: Cluster
    ## @param master.service.clusterIP Redis&reg; master service Cluster IP
    ##
    clusterIP: ""
    ## @param master.service.loadBalancerIP Redis&reg; master service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param master.service.loadBalancerClass master service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer
    ##
    loadBalancerClass: ""
    ## @param master.service.loadBalancerSourceRanges Redis&reg; master service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param master.service.externalIPs Redis&reg; master service External IPs
    ## https://kubernetes.io/docs/concepts/services-networking/service/#external-ips
    ## e.g.
    ## externalIPs:
    ##   - 10.10.10.1
    ##   - 201.22.30.1
    ##
    externalIPs: []
    ## @param master.service.annotations Additional custom annotations for Redis&reg; master service
    ##
    annotations: {}
    ## @param master.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param master.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
  ## @param master.terminationGracePeriodSeconds Integer setting the termination grace period for the redis-master pods
  ##
  terminationGracePeriodSeconds: 30
  ## ServiceAccount configuration
  ##
  serviceAccount:
    ## @param master.serviceAccount.create Specifies whether a ServiceAccount should be created
    ##
    create: true
    ## @param master.serviceAccount.name The name of the ServiceAccount to use.
    ## If not set and create is true, a name is generated using the common.names.fullname template
    ##
    name: ""
    ## @param master.serviceAccount.automountServiceAccountToken Whether to auto mount the service account token
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server
    ##
    automountServiceAccountToken: false
    ## @param master.serviceAccount.annotations Additional custom annotations for the ServiceAccount
    ##
    annotations: {}
  ## Pod Disruption Budget configuration
  ## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb
  ## @param master.pdb.create Enable/disable a Pod Disruption Budget creation
  ## @param master.pdb.minAvailable [object] Minimum number/percentage of pods that should remain scheduled
  ## @param master.pdb.maxUnavailable [object] Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `master.pdb.minAvailable` and `master.pdb.maxUnavailable` are empty.
  ##
  pdb:
    create: true
    minAvailable: ""
    maxUnavailable: ""
  ## @param master.extraPodSpec Optionally specify extra PodSpec for the Redis&reg; master pod(s)
  ##
  extraPodSpec: {}
  ## @param master.annotations Additional custom annotations for Redis&reg; Master resource
  ##
  annotations: {}
## @section Redis&reg; replicas configuration parameters
##
replica:
  ## @param replica.kind Use either DaemonSet or StatefulSet (default)
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
  ##
  kind: StatefulSet
  ## @param replica.replicaCount Number of Redis&reg; replicas to deploy
  ##
  replicaCount: 3
  ## @param replica.revisionHistoryLimit The number of old history to retain to allow rollback
  ## NOTE: Explicitly setting this field to 0, will result in cleaning up all the history, breaking ability to rollback
  revisionHistoryLimit: 10
  ## @param replica.configuration Configuration for Redis&reg; replicas nodes
  ## ref: https://redis.io/topics/config
  ##
  configuration: ""
  ## @param replica.disableCommands Array with Redis&reg; commands to disable on replicas nodes
  ## Commands will be completely disabled by renaming each to an empty string.
  ## ref: https://redis.io/topics/security#disabling-of-specific-commands
  ##
  disableCommands:
    - FLUSHDB
    - FLUSHALL
  ## @param replica.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param replica.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param replica.enableServiceLinks Whether information about services should be injected into pod's environment variable
  ##
  enableServiceLinks: true
  ## @param replica.preExecCmds Additional commands to run prior to starting Redis&reg; replicas
  ##
  preExecCmds: []
  ## @param replica.extraFlags Array with additional command line flags for Redis&reg; replicas
  ## e.g:
  ## extraFlags:
  ##  - "--maxmemory-policy volatile-ttl"
  ##  - "--repl-backlog-size 1024mb"
  ##
  extraFlags: []
  ## @param replica.extraEnvVars Array with extra environment variables to add to Redis&reg; replicas nodes
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## @param replica.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for Redis&reg; replicas nodes
  ##
  extraEnvVarsCM: ""
  ## @param replica.extraEnvVarsSecret Name of existing Secret containing extra env vars for Redis&reg; replicas nodes
  ##
  extraEnvVarsSecret: ""
  ## @param replica.externalMaster.enabled Use external master for bootstrapping
  ## @param replica.externalMaster.host External master host to bootstrap from
  ## @param replica.externalMaster.port Port for Redis service external master host
  ##
  externalMaster:
    enabled: false
    host: ""
    port: 6379
  ## @param replica.containerPorts.redis Container port to open on Redis&reg; replicas nodes
  ##
  containerPorts:
    redis: 6379
  ## Configure extra options for Redis&reg; containers' liveness and readiness probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param replica.startupProbe.enabled Enable startupProbe on Redis&reg; replicas nodes
  ## @param replica.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param replica.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param replica.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param replica.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param replica.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: true
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 22
  ## @param replica.livenessProbe.enabled Enable livenessProbe on Redis&reg; replicas nodes
  ## @param replica.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param replica.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param replica.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param replica.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param replica.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param replica.readinessProbe.enabled Enable readinessProbe on Redis&reg; replicas nodes
  ## @param replica.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param replica.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param replica.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param replica.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param replica.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 5
  ## @param replica.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param replica.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param replica.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## Redis&reg; replicas resource requests and limits
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ## @param replica.resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if replica.resources is set (replica.resources is recommended for production).
  ## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
  ##
  resourcesPreset: "nano"
  ## @param replica.resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
  ## Example:
  ## resources:
  ##   requests:
  ##     cpu: 2
  ##     memory: 512Mi
  ##   limits:
  ##     cpu: 3
  ##     memory: 1024Mi
  ##
  resources: {}
  ## Configure Pods Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param replica.podSecurityContext.enabled Enabled Redis&reg; replicas pods' Security Context
  ## @param replica.podSecurityContext.fsGroupChangePolicy Set filesystem group change policy
  ## @param replica.podSecurityContext.sysctls Set kernel settings using the sysctl interface
  ## @param replica.podSecurityContext.supplementalGroups Set filesystem extra groups
  ## @param replica.podSecurityContext.fsGroup Set Redis&reg; replicas pod's Security Context fsGroup
  ##
  podSecurityContext:
    enabled: true
    fsGroupChangePolicy: Always
    sysctls: []
    supplementalGroups: []
    fsGroup: 1001
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param replica.containerSecurityContext.enabled Enabled Redis&reg; replicas containers' Security Context
  ## @param replica.containerSecurityContext.seLinuxOptions [object,nullable] Set SELinux options in container
  ## @param replica.containerSecurityContext.runAsUser Set Redis&reg; replicas containers' Security Context runAsUser
  ## @param replica.containerSecurityContext.runAsGroup Set Redis&reg; replicas containers' Security Context runAsGroup
  ## @param replica.containerSecurityContext.runAsNonRoot Set Redis&reg; replicas containers' Security Context runAsNonRoot
  ## @param replica.containerSecurityContext.allowPrivilegeEscalation Set Redis&reg; replicas pod's Security Context allowPrivilegeEscalation
  ## @param replica.containerSecurityContext.readOnlyRootFilesystem Set container's Security Context read-only root filesystem
  ## @param replica.containerSecurityContext.seccompProfile.type Set Redis&reg; replicas containers' Security Context seccompProfile
  ## @param replica.containerSecurityContext.capabilities.drop Set Redis&reg; replicas containers' Security Context capabilities to drop
  ##
  containerSecurityContext:
    enabled: true
    seLinuxOptions: {}
    runAsUser: 1001
    runAsGroup: 1001
    runAsNonRoot: true
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    seccompProfile:
      type: RuntimeDefault
    capabilities:
      drop: ["ALL"]
  ## @param replica.schedulerName Alternate scheduler for Redis&reg; replicas pods
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param replica.updateStrategy.type Redis&reg; replicas statefulset strategy type
  ## @skip replica.updateStrategy.rollingUpdate
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy:
    ## StrategyType
    ## Can be set to RollingUpdate, OnDelete (statefulset), Recreate (deployment)
    ##
    type: RollingUpdate
  ## @param replica.minReadySeconds How many seconds a pod needs to be ready before killing the next, during update
  ##
  minReadySeconds: 0
  ## @param replica.priorityClassName Redis&reg; replicas pods' priorityClassName
  ##
  priorityClassName: ""
  ## @param replica.podManagementPolicy podManagementPolicy to manage scaling operation of %%MAIN_CONTAINER_NAME%% pods
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#pod-management-policies
  ##
  podManagementPolicy: ""
  ## @param replica.automountServiceAccountToken Mount Service Account token in pod
  ##
  automountServiceAccountToken: false
  ## @param replica.hostAliases Redis&reg; replicas pods host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param replica.podLabels Extra labels for Redis&reg; replicas pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  ##
  podLabels: {}
  ## @param replica.podAnnotations Annotations for Redis&reg; replicas pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param replica.shareProcessNamespace Share a single process namespace between all of the containers in Redis&reg; replicas pods
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/
  ##
  shareProcessNamespace: false
  ## @param replica.podAffinityPreset Pod affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param replica.podAntiAffinityPreset Pod anti-affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## Node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param replica.nodeAffinityPreset.type Node affinity preset type. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param replica.nodeAffinityPreset.key Node label key to match. Ignored if `replica.affinity` is set
    ##
    key: ""
    ## @param replica.nodeAffinityPreset.values Node label values to match. Ignored if `replica.affinity` is set
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param replica.affinity Affinity for Redis&reg; replicas pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## NOTE: `replica.podAffinityPreset`, `replica.podAntiAffinityPreset`, and `replica.nodeAffinityPreset` will be ignored when it's set
  ##
  affinity: {}
  ## @param replica.nodeSelector Node labels for Redis&reg; replicas pods assignment
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
  ##
  nodeSelector: {}
  ## @param replica.tolerations Tolerations for Redis&reg; replicas pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param replica.topologySpreadConstraints Spread Constraints for Redis&reg; replicas pod assignment
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ## E.g.
  ## topologySpreadConstraints:
  ##   - maxSkew: 1
  ##     topologyKey: node
  ##     whenUnsatisfiable: DoNotSchedule
  ##
  topologySpreadConstraints: []
  ## @param replica.dnsPolicy DNS Policy for Redis&reg; replica pods
  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
  ## E.g.
  ## dnsPolicy: ClusterFirst
  ##
  dnsPolicy: ""
  ## @param replica.dnsConfig DNS Configuration for Redis&reg; replica pods
  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
  ## E.g.
  ## dnsConfig:
  ##   options:
  ##   - name: ndots
  ##     value: "4"
  ##   - name: single-request-reopen
  ##
  dnsConfig: {}
  ## @param replica.lifecycleHooks for the Redis&reg; replica container(s) to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## @param replica.extraVolumes Optionally specify extra list of additional volumes for the Redis&reg; replicas pod(s)
  ##
  extraVolumes: []
  ## @param replica.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the Redis&reg; replicas container(s)
  ##
  extraVolumeMounts: []
  ## @param replica.sidecars Add additional sidecar containers to the Redis&reg; replicas pod(s)
  ## e.g:
  ## sidecars:
  ##   - name: your-image-name
  ##     image: your-image
  ##     imagePullPolicy: Always
  ##     ports:
  ##       - name: portname
  ##         containerPort: 1234
  ##
  sidecars: []
  ## @param replica.initContainers Add additional init containers to the Redis&reg; replicas pod(s)
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
  ## e.g:
  ## initContainers:
  ##  - name: your-image-name
  ##    image: your-image
  ##    imagePullPolicy: Always
  ##    command: ['sh', '-c', 'echo "hello world"']
  ##
  initContainers: []
  ## Persistence Parameters
  ## ref: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
  ##
  persistence:
    ## @param replica.persistence.enabled Enable persistence on Redis&reg; replicas nodes using Persistent Volume Claims
    ##
    enabled: true
    ## @param replica.persistence.medium Provide a medium for `emptyDir` volumes.
    ##
    medium: ""
    ## @param replica.persistence.sizeLimit Set this to enable a size limit for `emptyDir` volumes.
    ##
    sizeLimit: ""
    ##  @param replica.persistence.path The path the volume will be mounted at on Redis&reg; replicas containers
    ## NOTE: Useful when using different Redis&reg; images
    ##
    path: /data
    ## @param replica.persistence.subPath The subdirectory of the volume to mount on Redis&reg; replicas containers
    ## NOTE: Useful in dev environments
    ##
    subPath: ""
    ## @param replica.persistence.subPathExpr Used to construct the subPath subdirectory of the volume to mount on Redis&reg; replicas containers
    ##
    subPathExpr: ""
    ## @param replica.persistence.storageClass Persistent Volume storage class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner
    ##
    storageClass: ""
    ## @param replica.persistence.accessModes Persistent Volume access modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param replica.persistence.size Persistent Volume size
    ##
    size: 1Gi
    ## @param replica.persistence.annotations Additional custom annotations for the PVC
    ##
    annotations: {}
    ## @param replica.persistence.labels Additional custom labels for the PVC
    ##
    labels: {}
    ## @param replica.persistence.selector Additional labels to match for the PVC
    ## e.g:
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
    ## @param replica.persistence.dataSource Custom PVC data source
    ##
    dataSource: {}
    ## @param replica.persistence.existingClaim Use a existing PVC which must be created manually before bound
    ## NOTE: requires replica.persistence.enabled: true
    ##
    existingClaim: ""
  ## persistentVolumeClaimRetentionPolicy
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#persistentvolumeclaim-retention
  ## @param replica.persistentVolumeClaimRetentionPolicy.enabled Controls if and how PVCs are deleted during the lifecycle of a StatefulSet
  ## @param replica.persistentVolumeClaimRetentionPolicy.whenScaled Volume retention behavior when the replica count of the StatefulSet is reduced
  ## @param replica.persistentVolumeClaimRetentionPolicy.whenDeleted Volume retention behavior that applies when the StatefulSet is deleted
  ##
  persistentVolumeClaimRetentionPolicy:
    enabled: false
    whenScaled: Retain
    whenDeleted: Retain
  ## Redis&reg; replicas service parameters
  ##
  service:
    ## @param replica.service.type Redis&reg; replicas service type
    ##
    type: ClusterIP
    ## @param replica.service.ports.redis Redis&reg; replicas service port
    ##
    ports:
      redis: 6379
    ## @param replica.service.nodePorts.redis Node port for Redis&reg; replicas
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ## NOTE: choose port between <30000-32767>
    ##
    nodePorts:
      redis: ""
    ## @param replica.service.externalTrafficPolicy Redis&reg; replicas service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param replica.service.internalTrafficPolicy Redis&reg; replicas service internal traffic policy (requires Kubernetes v1.22 or greater to be usable)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service-traffic-policy/
    ##
    internalTrafficPolicy: Cluster
    ## @param replica.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param replica.service.clusterIP Redis&reg; replicas service Cluster IP
    ##
    clusterIP: ""
    ## @param replica.service.loadBalancerIP Redis&reg; replicas service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param replica.service.loadBalancerClass replicas service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer
    ##
    loadBalancerClass: ""
    ## @param replica.service.loadBalancerSourceRanges Redis&reg; replicas service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param replica.service.annotations Additional custom annotations for Redis&reg; replicas service
    ##
    annotations: {}
    ## @param replica.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param replica.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
  ## @param replica.terminationGracePeriodSeconds Integer setting the termination grace period for the redis-replicas pods
  ##
  terminationGracePeriodSeconds: 30
  ## Autoscaling configuration
  ##
  autoscaling:
    ## @param replica.autoscaling.enabled Enable replica autoscaling settings
    ##
    enabled: false
    ## @param replica.autoscaling.minReplicas Minimum replicas for the pod autoscaling
    ##
    minReplicas: 1
    ## @param replica.autoscaling.maxReplicas Maximum replicas for the pod autoscaling
    ##
    maxReplicas: 11
    ## @param replica.autoscaling.targetCPU Percentage of CPU to consider when autoscaling
    ##
    targetCPU: ""
    ## @param replica.autoscaling.targetMemory Percentage of Memory to consider when autoscaling
    ##
    targetMemory: ""
  ## ServiceAccount configuration
  ##
  serviceAccount:
    ## @param replica.serviceAccount.create Specifies whether a ServiceAccount should be created
    ##
    create: true
    ## @param replica.serviceAccount.name The name of the ServiceAccount to use.
    ## If not set and create is true, a name is generated using the common.names.fullname template
    ##
    name: ""
    ## @param replica.serviceAccount.automountServiceAccountToken Whether to auto mount the service account token
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server
    ##
    automountServiceAccountToken: false
    ## @param replica.serviceAccount.annotations Additional custom annotations for the ServiceAccount
    ##
    annotations: {}
  ## Pod Disruption Budget configuration
  ## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb
  ## @param replica.pdb.create Enable/disable a Pod Disruption Budget creation
  ## @param replica.pdb.minAvailable [object] Minimum number/percentage of pods that should remain scheduled
  ## @param replica.pdb.maxUnavailable [object] Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `replica.pdb.minAvailable` and `replica.pdb.maxUnavailable` are empty.
  ##
  pdb:
    create: true
    minAvailable: ""
    maxUnavailable: ""
  ## @param replica.extraPodSpec Optionally specify extra PodSpec for the Redis&reg; replicas pod(s)
  ##
  extraPodSpec: {}
  ## @param replica.annotations Additional custom annotations for Redis&reg; replicas resource
    ##
    annotations: {}
## @section Redis&reg; Sentinel configuration parameters
##

sentinel:
  ## @param sentinel.enabled Use Redis&reg; Sentinel on Redis&reg; pods.
  ## IMPORTANT: this will disable the master and replicas services and
  ## create a single Redis&reg; service exposing both the Redis and Sentinel ports
  ##
  enabled: false
  ## Bitnami Redis&reg; Sentinel image version
  ## ref: https://hub.docker.com/r/bitnami/redis-sentinel/tags/
  ## @param sentinel.image.registry [default: REGISTRY_NAME] Redis&reg; Sentinel image registry
  ## @param sentinel.image.repository [default: REPOSITORY_NAME/redis-sentinel] Redis&reg; Sentinel image repository
  ## @skip sentinel.image.tag Redis&reg; Sentinel image tag (immutable tags are recommended)
  ## @param sentinel.image.digest Redis&reg; Sentinel image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param sentinel.image.pullPolicy Redis&reg; Sentinel image pull policy
  ## @param sentinel.image.pullSecrets Redis&reg; Sentinel image pull secrets
  ## @param sentinel.image.debug Enable image debug mode
  ##
  image:
    registry: docker.io
    repository: bitnami/redis-sentinel
    tag: 7.4.2-debian-12-r0
    digest: ""
    ## Specify a imagePullPolicy
    ## ref: https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images
    ##
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
    ## Enable debug mode
    ##
    debug: false
  ## @param sentinel.annotations Additional custom annotations for Redis&reg; Sentinel resource
  ##
  annotations: {}
  ## @param sentinel.masterSet Master set name
  ##
  masterSet: mymaster
  ## @param sentinel.quorum Sentinel Quorum
  ##
  quorum: 2
  ## @param sentinel.getMasterTimeout Amount of time to allow before get_sentinel_master_info() times out.
  ##
  getMasterTimeout: 90
  ## @param sentinel.automateClusterRecovery Automate cluster recovery in cases where the last replica is not considered a good replica and Sentinel won't automatically failover to it.
  ## This also prevents any new replica from starting until the last remaining replica is elected as master to guarantee that it is the one to be elected by Sentinel, and not a newly started replica with no data.
  ## NOTE: This feature requires a "downAfterMilliseconds" value less or equal to 2000.
  ##
  automateClusterRecovery: false
  ## @param sentinel.redisShutdownWaitFailover Whether the Redis&reg; master container waits for the failover at shutdown (in addition to the Redis&reg; Sentinel container).
  ##
  redisShutdownWaitFailover: true
  ## Sentinel timing restrictions
  ## @param sentinel.downAfterMilliseconds Timeout for detecting a Redis&reg; node is down
  ## @param sentinel.failoverTimeout Timeout for performing a election failover
  ##
  downAfterMilliseconds: 60000
  failoverTimeout: 180000
  ## @param sentinel.parallelSyncs Number of replicas that can be reconfigured in parallel to use the new master after a failover
  ##
  parallelSyncs: 1
  ## @param sentinel.configuration Configuration for Redis&reg; Sentinel nodes
  ## ref: https://redis.io/topics/sentinel
  ##
  configuration: ""
  ## @param sentinel.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param sentinel.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param sentinel.enableServiceLinks Whether information about services should be injected into pod's environment variable
  ##
  enableServiceLinks: true
  ## @param sentinel.preExecCmds Additional commands to run prior to starting Redis&reg; Sentinel
  ##
  preExecCmds: []
  ## @param sentinel.extraEnvVars Array with extra environment variables to add to Redis&reg; Sentinel nodes
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## @param sentinel.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for Redis&reg; Sentinel nodes
  ##
  extraEnvVarsCM: ""
  ## @param sentinel.extraEnvVarsSecret Name of existing Secret containing extra env vars for Redis&reg; Sentinel nodes
  ##
  extraEnvVarsSecret: ""
  ## @param sentinel.externalMaster.enabled Use external master for bootstrapping
  ## @param sentinel.externalMaster.host External master host to bootstrap from
  ## @param sentinel.externalMaster.port Port for Redis service external master host
  ##
  externalMaster:
    enabled: false
    host: ""
    port: 6379
  ## @param sentinel.containerPorts.sentinel Container port to open on Redis&reg; Sentinel nodes
  ##
  containerPorts:
    sentinel: 26379
  ## Configure extra options for Redis&reg; containers' liveness and readiness probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param sentinel.startupProbe.enabled Enable startupProbe on Redis&reg; Sentinel nodes
  ## @param sentinel.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param sentinel.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param sentinel.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param sentinel.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param sentinel.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: true
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 22
  ## @param sentinel.livenessProbe.enabled Enable livenessProbe on Redis&reg; Sentinel nodes
  ## @param sentinel.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param sentinel.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param sentinel.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param sentinel.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param sentinel.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6
  ## @param sentinel.readinessProbe.enabled Enable readinessProbe on Redis&reg; Sentinel nodes
  ## @param sentinel.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param sentinel.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param sentinel.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param sentinel.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param sentinel.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 6
  ## @param sentinel.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param sentinel.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param sentinel.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## Persistence parameters
  ## ref: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
  ##
  persistence:
    ## @param sentinel.persistence.enabled Enable persistence on Redis&reg; sentinel nodes using Persistent Volume Claims (Experimental)
    ##
    enabled: false
    ## @param sentinel.persistence.storageClass Persistent Volume storage class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner
    ##
    storageClass: ""
    ## @param sentinel.persistence.accessModes Persistent Volume access modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param sentinel.persistence.size Persistent Volume size
    ##
    size: 100Mi
    ## @param sentinel.persistence.annotations Additional custom annotations for the PVC
    ##
    annotations: {}
    ## @param sentinel.persistence.labels Additional custom labels for the PVC
    ##
    labels: {}
    ## @param sentinel.persistence.selector Additional labels to match for the PVC
    ## e.g:
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
    ## @param sentinel.persistence.dataSource Custom PVC data source
    ##
    dataSource: {}
    ## @param sentinel.persistence.medium Provide a medium for `emptyDir` volumes.
    ##
    medium: ""
    ## @param sentinel.persistence.sizeLimit Set this to enable a size limit for `emptyDir` volumes.
    ##
    sizeLimit: ""
  ## persistentVolumeClaimRetentionPolicy
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#persistentvolumeclaim-retention
  ## @param sentinel.persistentVolumeClaimRetentionPolicy.enabled Controls if and how PVCs are deleted during the lifecycle of a StatefulSet
  ## @param sentinel.persistentVolumeClaimRetentionPolicy.whenScaled Volume retention behavior when the replica count of the StatefulSet is reduced
  ## @param sentinel.persistentVolumeClaimRetentionPolicy.whenDeleted Volume retention behavior that applies when the StatefulSet is deleted
  ##
  persistentVolumeClaimRetentionPolicy:
    enabled: false
    whenScaled: Retain
    whenDeleted: Retain
  ## Redis&reg; Sentinel resource requests and limits
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ## @param sentinel.resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sentinel.resources is set (sentinel.resources is recommended for production).
  ## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
  ##
  resourcesPreset: "nano"
  ## @param sentinel.resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
  ## Example:
  ## resources:
  ##   requests:
  ##     cpu: 2
  ##     memory: 512Mi
  ##   limits:
  ##     cpu: 3
  ##     memory: 1024Mi
  ##
  resources: {}
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param sentinel.containerSecurityContext.enabled Enabled Redis&reg; Sentinel containers' Security Context
  ## @param sentinel.containerSecurityContext.seLinuxOptions [object,nullable] Set SELinux options in container
  ## @param sentinel.containerSecurityContext.runAsUser Set Redis&reg; Sentinel containers' Security Context runAsUser
  ## @param sentinel.containerSecurityContext.runAsGroup Set Redis&reg; Sentinel containers' Security Context runAsGroup
  ## @param sentinel.containerSecurityContext.runAsNonRoot Set Redis&reg; Sentinel containers' Security Context runAsNonRoot
  ## @param sentinel.containerSecurityContext.readOnlyRootFilesystem Set container's Security Context read-only root filesystem
  ## @param sentinel.containerSecurityContext.allowPrivilegeEscalation Set Redis&reg; Sentinel containers' Security Context allowPrivilegeEscalation
  ## @param sentinel.containerSecurityContext.seccompProfile.type Set Redis&reg; Sentinel containers' Security Context seccompProfile
  ## @param sentinel.containerSecurityContext.capabilities.drop Set Redis&reg; Sentinel containers' Security Context capabilities to drop
  ##
  containerSecurityContext:
    enabled: true
    seLinuxOptions: {}
    runAsUser: 1001
    runAsGroup: 1001
    runAsNonRoot: true
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    seccompProfile:
      type: RuntimeDefault
    capabilities:
      drop: ["ALL"]
  ## @param sentinel.lifecycleHooks for the Redis&reg; sentinel container(s) to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## @param sentinel.extraVolumes Optionally specify extra list of additional volumes for the Redis&reg; Sentinel
  ##
  extraVolumes: []
  ## @param sentinel.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the Redis&reg; Sentinel container(s)
  ##
  extraVolumeMounts: []
  ## Redis&reg; Sentinel service parameters
  ## Note: values passed in this section also configure the master service, unless the sentinel.masterService is explicitly overridden.
  service:
    ## @param sentinel.service.type Redis&reg; Sentinel service type
    ##
    type: ClusterIP
    ## @param sentinel.service.ports.redis Redis&reg; service port for Redis&reg;
    ## @param sentinel.service.ports.sentinel Redis&reg; service port for Redis&reg; Sentinel
    ##
    ports:
      redis: 6379
      sentinel: 26379
    ## @param sentinel.service.nodePorts.redis Node port for Redis&reg;
    ## @param sentinel.service.nodePorts.sentinel Node port for Sentinel
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ## NOTE: choose port between <30000-32767>
    ## NOTE: By leaving these values blank, they will be generated by ports-configmap
    ##       If setting manually, please leave at least replica.replicaCount + 1 in between sentinel.service.nodePorts.redis and sentinel.service.nodePorts.sentinel to take into account the ports that will be created while incrementing that base port
    ##
    nodePorts:
      redis: ""
      sentinel: ""
    ## @param sentinel.service.externalTrafficPolicy Redis&reg; Sentinel service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param sentinel.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param sentinel.service.clusterIP Redis&reg; Sentinel service Cluster IP
    ##
    clusterIP: ""
    ## @param sentinel.service.createMaster Enable master service pointing to the current master (experimental)
    ## NOTE: rbac.create need to be set to true
    ##
    createMaster: false

    ## @param sentinel.service.loadBalancerIP Redis&reg; Sentinel service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param sentinel.service.loadBalancerClass sentinel service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer
    ##
    loadBalancerClass: ""
    ## @param sentinel.service.loadBalancerSourceRanges Redis&reg; Sentinel service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param sentinel.service.annotations Additional custom annotations for Redis&reg; Sentinel service
    ##
    annotations: {}
    ## @param sentinel.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param sentinel.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
    ## Headless service properties
    ##
    headless:
      ## @param sentinel.service.headless.annotations Annotations for the headless service.
      ##
      annotations: {}
      ## @param sentinel.service.headless.extraPorts Optionally specify extra ports to expose for the headless service.
      ## Example:
      ## extraPorts:
      ##   - name: my-custom-port
      ##     port: 12345
      ##     protocol: TCP
      ##     targetPort: 12345
      ##
      extraPorts: []
  ## Redis&reg; master service parameters
  ##
  masterService:
    ## @param sentinel.masterService.enabled Enable master service pointing to the current master (experimental)
    ## NOTE: rbac.create need to be set to true
    ##
    enabled: false
    ## @param sentinel.masterService.type Redis&reg; Sentinel master service type
    ##
    type: ClusterIP
    ## @param sentinel.masterService.ports.redis Redis&reg; service port for Redis&reg;
    ##
    ports:
      redis: 6379
    ## @param sentinel.masterService.nodePorts.redis Node port for Redis&reg;
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ## NOTE: choose port between <30000-32767>
    ## NOTE: By leaving these values blank, they will be generated by ports-configmap
    ##       If setting manually, please leave at least replica.replicaCount + 1 in between sentinel.service.nodePorts.redis and sentinel.service.nodePorts.sentinel to take into account the ports that will be created while incrementing that base port
    ##
    nodePorts:
      redis: ""
    ## @param sentinel.masterService.externalTrafficPolicy Redis&reg; master service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: ""
    ## @param sentinel.masterService.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param sentinel.masterService.clusterIP Redis&reg; master service Cluster IP
    ##
    clusterIP: ""
    ## @param sentinel.masterService.loadBalancerIP Redis&reg; master service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param sentinel.masterService.loadBalancerClass master service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer
    ##
    loadBalancerClass: ""
    ## @param sentinel.masterService.loadBalancerSourceRanges Redis&reg; master service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param sentinel.masterService.annotations Additional custom annotations for Redis&reg; master service
    ##
    annotations: {}
    ## @param sentinel.masterService.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param sentinel.masterService.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
  ## @param sentinel.terminationGracePeriodSeconds Integer setting the termination grace period for the redis-node pods
  ##
  terminationGracePeriodSeconds: 30
  ## @param sentinel.extraPodSpec Optionally specify extra PodSpec for the Redis&reg; Sentinel pod(s)
  ##
  extraPodSpec: {}
## @section Other Parameters
##

## @param serviceBindings.enabled Create secret for service binding (Experimental)
## Ref: https://servicebinding.io/service-provider/
##
serviceBindings:
  enabled: false
## Network Policy configuration
## ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/
##
networkPolicy:
  ## @param networkPolicy.enabled Enable creation of NetworkPolicy resources
  ##
  enabled: true
  ## @param networkPolicy.allowExternal Don't require client label for connections
  ## When set to false, only pods with the correct client label will have network access to the ports
  ## Redis&reg; is listening on. When true, Redis&reg; will accept connections from any source
  ## (with the correct destination port).
  ##
  allowExternal: true
  ## @param networkPolicy.allowExternalEgress Allow the pod to access any range of port and all destinations.
  ##
  allowExternalEgress: true
  ## @param networkPolicy.extraIngress Add extra ingress rules to the NetworkPolicy
  ## e.g:
  ## extraIngress:
  ##   - ports:
  ##       - port: 1234
  ##     from:
  ##       - podSelector:
  ##           - matchLabels:
  ##               - role: frontend
  ##       - podSelector:
  ##           - matchExpressions:
  ##               - key: role
  ##                 operator: In
  ##                 values:
  ##                   - frontend
  ##
  extraIngress: []
  ## @param networkPolicy.extraEgress Add extra egress rules to the NetworkPolicy
  ## e.g:
  ## extraEgress:
  ##   - ports:
  ##       - port: 1234
  ##     to:
  ##       - podSelector:
  ##           - matchLabels:
  ##               - role: frontend
  ##       - podSelector:
  ##           - matchExpressions:
  ##               - key: role
  ##                 operator: In
  ##                 values:
  ##                   - frontend
  ##
  extraEgress: []
  ## @param networkPolicy.ingressNSMatchLabels Labels to match to allow traffic from other namespaces
  ## @param networkPolicy.ingressNSPodMatchLabels Pod labels to match to allow traffic from other namespaces
  ##
  ingressNSMatchLabels: {}
  ingressNSPodMatchLabels: {}
  metrics:
    ## @param networkPolicy.metrics.allowExternal Don't require client label for connections for metrics endpoint
    ## When set to false, only pods with the correct client label will have network access to the metrics port
    ##
    allowExternal: true
    ## @param networkPolicy.metrics.ingressNSMatchLabels Labels to match to allow traffic from other namespaces to metrics endpoint
    ## @param networkPolicy.metrics.ingressNSPodMatchLabels Pod labels to match to allow traffic from other namespaces to metrics endpoint
    ##
    ingressNSMatchLabels: {}
    ingressNSPodMatchLabels: {}
## PodSecurityPolicy configuration
## ref: https://kubernetes.io/docs/concepts/policy/pod-security-policy/
##
podSecurityPolicy:
  ## @param podSecurityPolicy.create Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later
  ##
  create: false
  ## @param podSecurityPolicy.enabled Enable PodSecurityPolicy's RBAC rules
  ##
  enabled: false
## RBAC configuration
##
rbac:
  ## @param rbac.create Specifies whether RBAC resources should be created
  ##
  create: false
  ## @param rbac.rules Custom RBAC rules to set
  ## e.g:
  ## rules:
  ##   - apiGroups:
  ##       - ""
  ##     resources:
  ##       - pods
  ##     verbs:
  ##       - get
  ##       - list
  ##
  rules: []
## ServiceAccount configuration
##
serviceAccount:
  ## @param serviceAccount.create Specifies whether a ServiceAccount should be created
  ##
  create: true
  ## @param serviceAccount.name The name of the ServiceAccount to use.
  ## If not set and create is true, a name is generated using the common.names.fullname template
  ##
  name: ""
  ## @param serviceAccount.automountServiceAccountToken Whether to auto mount the service account token
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server
  ##
  automountServiceAccountToken: false
  ## @param serviceAccount.annotations Additional custom annotations for the ServiceAccount
  ##
  annotations: {}
## Redis&reg; Pod Disruption Budget configuration
## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
## @param pdb DEPRECATED Please use `master.pdb` and `replica.pdb` values instead
##
pdb: {}
## TLS configuration
##
tls:
  ## @param tls.enabled Enable TLS traffic
  ##
  enabled: false
  ## @param tls.authClients Require clients to authenticate
  ##
  authClients: true
  ## @param tls.autoGenerated Enable autogenerated certificates
  ##
  autoGenerated: false
  ## @param tls.existingSecret The name of the existing secret that contains the TLS certificates
  ##
  existingSecret: ""
  ## @param tls.certificatesSecret DEPRECATED. Use existingSecret instead.
  ##
  certificatesSecret: ""
  ## @param tls.certFilename Certificate filename
  ##
  certFilename: ""
  ## @param tls.certKeyFilename Certificate Key filename
  ##
  certKeyFilename: ""
  ## @param tls.certCAFilename CA Certificate filename
  ##
  certCAFilename: ""
  ## @param tls.dhParamsFilename File containing DH params (in order to support DH based ciphers)
  ##
  dhParamsFilename: ""
## @section Metrics Parameters
##
metrics:
  ## @param metrics.enabled Start a sidecar prometheus exporter to expose Redis&reg; metrics
  ##
  enabled: false
  ## Bitnami Redis&reg; Exporter image
  ## ref: https://hub.docker.com/r/bitnami/redis-exporter/tags/
  ## @param metrics.image.registry [default: REGISTRY_NAME] Redis&reg; Exporter image registry
  ## @param metrics.image.repository [default: REPOSITORY_NAME/redis-exporter] Redis&reg; Exporter image repository
  ## @skip metrics.image.tag Redis&reg; Exporter image tag (immutable tags are recommended)
  ## @param metrics.image.digest Redis&reg; Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param metrics.image.pullPolicy Redis&reg; Exporter image pull policy
  ## @param metrics.image.pullSecrets Redis&reg; Exporter image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/redis-exporter
    tag: 1.67.0-debian-12-r0
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param metrics.containerPorts.http Metrics HTTP container port
  ##
  containerPorts:
    http: 9121
  ## Configure extra options for Redis&reg; containers' liveness, readiness & startup probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
  ## @param metrics.startupProbe.enabled Enable startupProbe on Redis&reg; replicas nodes
  ## @param metrics.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param metrics.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param metrics.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param metrics.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param metrics.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param metrics.livenessProbe.enabled Enable livenessProbe on Redis&reg; replicas nodes
  ## @param metrics.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param metrics.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param metrics.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param metrics.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param metrics.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param metrics.readinessProbe.enabled Enable readinessProbe on Redis&reg; replicas nodes
  ## @param metrics.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param metrics.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param metrics.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param metrics.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param metrics.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 3
  ## @param metrics.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param metrics.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param metrics.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## @param metrics.command Override default metrics container init command (useful when using custom images)
  ##
  command: []
  ## @param metrics.redisTargetHost A way to specify an alternative Redis&reg; hostname
  ## Useful for certificate CN/SAN matching
  ##
  redisTargetHost: "localhost"
  ## @param metrics.extraArgs Extra arguments for Redis&reg; exporter, for example:
  ## e.g.:
  ## extraArgs:
  ##   check-keys: myKey,myOtherKey
  ##
  extraArgs: {}
  ## @param metrics.extraEnvVars Array with extra environment variables to add to Redis&reg; exporter
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param metrics.containerSecurityContext.enabled Enabled Redis&reg; exporter containers' Security Context
  ## @param metrics.containerSecurityContext.seLinuxOptions [object,nullable] Set SELinux options in container
  ## @param metrics.containerSecurityContext.runAsUser Set Redis&reg; exporter containers' Security Context runAsUser
  ## @param metrics.containerSecurityContext.runAsGroup Set Redis&reg; exporter containers' Security Context runAsGroup
  ## @param metrics.containerSecurityContext.runAsNonRoot Set Redis&reg; exporter containers' Security Context runAsNonRoot
  ## @param metrics.containerSecurityContext.allowPrivilegeEscalation Set Redis&reg; exporter containers' Security Context allowPrivilegeEscalation
  ## @param metrics.containerSecurityContext.readOnlyRootFilesystem Set container's Security Context read-only root filesystem
  ## @param metrics.containerSecurityContext.seccompProfile.type Set Redis&reg; exporter containers' Security Context seccompProfile
  ## @param metrics.containerSecurityContext.capabilities.drop Set Redis&reg; exporter containers' Security Context capabilities to drop
  ##
  containerSecurityContext:
    enabled: true
    seLinuxOptions: {}
    runAsUser: 1001
    runAsGroup: 1001
    runAsNonRoot: true
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    seccompProfile:
      type: RuntimeDefault
    capabilities:
      drop: ["ALL"]
  ## @param metrics.extraVolumes Optionally specify extra list of additional volumes for the Redis&reg; metrics sidecar
  ##
  extraVolumes: []
  ## @param metrics.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the Redis&reg; metrics sidecar
  ##
  extraVolumeMounts: []
  ## Redis&reg; exporter resource requests and limits
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ## @param metrics.resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if metrics.resources is set (metrics.resources is recommended for production).
  ## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
  ##
  resourcesPreset: "nano"
  ## @param metrics.resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
  ## Example:
  ## resources:
  ##   requests:
  ##     cpu: 2
  ##     memory: 512Mi
  ##   limits:
  ##     cpu: 3
  ##     memory: 1024Mi
  ##
  resources: {}
  ## @param metrics.podLabels Extra labels for Redis&reg; exporter pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  ##
  podLabels: {}
  ## @param metrics.podAnnotations [object] Annotations for Redis&reg; exporter pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9121"
  ## Redis&reg; exporter service parameters
  ##
  service:
    ## @param metrics.service.enabled Create Service resource(s) for scraping metrics using PrometheusOperator ServiceMonitor, can be disabled when using a PodMonitor
    ##
    enabled: true
    ## @param metrics.service.type Redis&reg; exporter service type
    ##
    type: ClusterIP
    ## @param metrics.service.ports.http Redis&reg; exporter service port
    ##
    ports:
      http: 9121
    ## @param metrics.service.externalTrafficPolicy Redis&reg; exporter service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param metrics.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param metrics.service.loadBalancerIP Redis&reg; exporter service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param metrics.service.loadBalancerClass exporter service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer
    ##
    loadBalancerClass: ""
    ## @param metrics.service.loadBalancerSourceRanges Redis&reg; exporter service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param metrics.service.annotations Additional custom annotations for Redis&reg; exporter service
    ##
    annotations: {}
    ## @param metrics.service.clusterIP Redis&reg; exporter service Cluster IP
    ##
    clusterIP: ""
  ## Prometheus Service Monitor
  ## ref: https://github.com/coreos/prometheus-operator
  ##      https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint
  ##
  serviceMonitor:
    ## @param metrics.serviceMonitor.port the service port to scrape metrics from
    ##
    port: http-metrics
    ## @param metrics.serviceMonitor.enabled Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator
    ##
    enabled: false
    ## @param metrics.serviceMonitor.namespace The namespace in which the ServiceMonitor will be created
    ##
    namespace: ""
    ## @param metrics.serviceMonitor.interval The interval at which metrics should be scraped
    ##
    interval: 30s
    ## @param metrics.serviceMonitor.scrapeTimeout The timeout after which the scrape is ended
    ##
    scrapeTimeout: ""
    ## @param metrics.serviceMonitor.relabelings Metrics RelabelConfigs to apply to samples before scraping.
    ##
    relabelings: []
    ## @skip metrics.serviceMonitor.relabellings DEPRECATED: Use `metrics.serviceMonitor.relabelings` instead.
    ##
    relabellings: []
    ## @param metrics.serviceMonitor.metricRelabelings Metrics RelabelConfigs to apply to samples before ingestion.
    ##
    metricRelabelings: []
    ## @param metrics.serviceMonitor.honorLabels Specify honorLabels parameter to add the scrape endpoint
    ##
    honorLabels: false
    ## @param metrics.serviceMonitor.additionalLabels Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus
    ##
    additionalLabels: {}
    ## @param metrics.serviceMonitor.podTargetLabels Labels from the Kubernetes pod to be transferred to the created metrics
    ##
    podTargetLabels: []
    ## @param metrics.serviceMonitor.sampleLimit Limit of how many samples should be scraped from every Pod
    ##
    sampleLimit: false
    ## @param metrics.serviceMonitor.targetLimit Limit of how many targets should be scraped
    ##
    targetLimit: false
    ## @param metrics.serviceMonitor.additionalEndpoints  Additional endpoints to scrape (e.g sentinel)
    ##
    additionalEndpoints: []
    # uncomment in order to scrape sentinel metrics, also to in order distinguish between Sentinel and Redis container metrics
    # add metricRelabelings with label like app=redis to main redis pod-monitor port
    # - interval: "30s"
    #   path: "/scrape"
    #   port: "http-metrics"
      #   params:
    #     target: ["localhost:26379"]
    #   metricRelabelings:
    #     - targetLabel: "app"
    #       replacement: "sentinel"
  ## Prometheus Pod Monitor
  ## ref: https://github.com/coreos/prometheus-operator
  ##      https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#podmonitor
  ##
  podMonitor:
    ## @param metrics.podMonitor.port the pod port to scrape metrics from
    ##
    port: metrics
    ## @param metrics.podMonitor.enabled Create PodMonitor resource(s) for scraping metrics using PrometheusOperator
    ##
    enabled: false
    ## @param metrics.podMonitor.namespace The namespace in which the PodMonitor will be created
    ##
    namespace: ""
    ## @param metrics.podMonitor.interval The interval at which metrics should be scraped
    ##
    interval: 30s
    ## @param metrics.podMonitor.scrapeTimeout The timeout after which the scrape is ended
    ##
    scrapeTimeout: ""
    ## @param metrics.podMonitor.relabelings Metrics RelabelConfigs to apply to samples before scraping.
    ##
    relabelings: []
    ## @skip metrics.podMonitor.relabellings DEPRECATED: Use `metrics.podMonitor.relabelings` instead.
    ##
    relabellings: []
    ## @param metrics.podMonitor.metricRelabelings Metrics RelabelConfigs to apply to samples before ingestion.
    ##
    metricRelabelings: []
    # - targetLabel: "app"
    #   replacement: "redis"
    ## @param metrics.podMonitor.honorLabels Specify honorLabels parameter to add the scrape endpoint
    ##
    honorLabels: false
    ## @param metrics.podMonitor.additionalLabels Additional labels that can be used so PodMonitor resource(s) can be discovered by Prometheus
    ##
    additionalLabels: {}
    ## @param metrics.podMonitor.podTargetLabels Labels from the Kubernetes pod to be transferred to the created metrics
    ##
    podTargetLabels: []
    ## @param metrics.podMonitor.sampleLimit Limit of how many samples should be scraped from every Pod
    ##
    sampleLimit: false
    ## @param metrics.podMonitor.targetLimit Limit of how many targets should be scraped
    ##
    targetLimit: false
    ## @param metrics.podMonitor.additionalEndpoints  Additional endpoints to scrape (e.g sentinel)
    ##
    additionalEndpoints: []
    # - interval: "30s"
    #   path: "/scrape"
    #   port: "metrics"
      #   params:
    #     target: ["localhost:26379"]
    #   metricRelabelings:
    #     - targetLabel: "app"
    #       replacement: "sentinel"
  ## Custom PrometheusRule to be defined
  ## ref: https://github.com/coreos/prometheus-operator#customresourcedefinitions
  ##
  prometheusRule:
    ## @param metrics.prometheusRule.enabled Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator
    ##
    enabled: false
    ## @param metrics.prometheusRule.namespace The namespace in which the prometheusRule will be created
    ##
    namespace: ""
    ## @param metrics.prometheusRule.additionalLabels Additional labels for the prometheusRule
    ##
    additionalLabels: {}
    ## @param metrics.prometheusRule.rules Custom Prometheus rules
    ## e.g:
    ## rules:
    ##   - alert: RedisDown
    ##     expr: redis_up{service="*- template "common.names.fullname" . -*-metrics"} == 0
    ##     for: 2m
    ##     labels:
    ##       severity: error
    ##     annotations:
    ##       summary: Redis&reg; instance *- "*- $labels.instance -*" -* down
    ##       description: Redis&reg; instance *- "*- $labels.instance -*" -* is down
    ##    - alert: RedisMemoryHigh
    ##      expr: >
    ##        redis_memory_used_bytes{service="*- template "common.names.fullname" . -*-metrics"} * 100
    ##        /
    ##        redis_memory_max_bytes{service="*- template "common.names.fullname" . -*-metrics"}
    ##        > 90
    ##      for: 2m
    ##      labels:
    ##        severity: error
    ##      annotations:
    ##        summary: Redis&reg; instance *- "*- $labels.instance -*" -* is using too much memory
    ##        description: |
    ##          Redis&reg; instance *- "*- $labels.instance -*" -* is using *- "*- $value -*" -*% of its available memory.
    ##    - alert: RedisKeyEviction
    ##      expr: |
    ##        increase(redis_evicted_keys_total{service="*- template "common.names.fullname" . -*-metrics"}[5m]) > 0
    ##      for: 1s
    ##      labels:
    ##        severity: error
    ##      annotations:
    ##        summary: Redis&reg; instance *- "*- $labels.instance -*" -* has evicted keys
    ##        description: |
    ##          Redis&reg; instance *- "*- $labels.instance -*" -* has evicted *- "*- $value -*" -* keys in the last 5 minutes.
    ##
    rules: []
## @section Init Container Parameters
##

## 'volumePermissions' init container parameters
## Changes the owner and group of the persistent volume mount point to runAsUser:fsGroup values
##   based on the *podSecurityContext/*containerSecurityContext parameters
##
volumePermissions:
  ## @param volumePermissions.enabled Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`
  ##
  enabled: false
  ## OS Shell + Utility image
  ## ref: https://hub.docker.com/r/bitnami/os-shell/tags/
  ## @param volumePermissions.image.registry [default: REGISTRY_NAME] OS Shell + Utility image registry
  ## @param volumePermissions.image.repository [default: REPOSITORY_NAME/os-shell] OS Shell + Utility image repository
  ## @skip volumePermissions.image.tag OS Shell + Utility image tag (immutable tags are recommended)
  ## @param volumePermissions.image.digest OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param volumePermissions.image.pullPolicy OS Shell + Utility image pull policy
  ## @param volumePermissions.image.pullSecrets OS Shell + Utility image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/os-shell
    tag: 12-debian-12-r34
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## Init container's resource requests and limits
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ## @param volumePermissions.resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production).
  ## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
  ##
  resourcesPreset: "nano"
  ## @param volumePermissions.resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
  ## Example:
  ## resources:
  ##   requests:
  ##     cpu: 2
  ##     memory: 512Mi
  ##   limits:
  ##     cpu: 3
  ##     memory: 1024Mi
  ##
  resources: {}
  ## Init container Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  ## @param volumePermissions.containerSecurityContext.seLinuxOptions [object,nullable] Set SELinux options in container
  ## @param volumePermissions.containerSecurityContext.runAsUser Set init container's Security Context runAsUser
  ## NOTE: when runAsUser is set to special value "auto", init container will try to chown the
  ##   data folder to auto-determined user&group, using commands: `id -u`:`id -G | cut -d" " -f2`
  ##   "auto" is especially useful for OpenShift which has scc with dynamic user ids (and 0 is not allowed)
  ##
  containerSecurityContext:
    seLinuxOptions: {}
    runAsUser: 0

  ## @param volumePermissions.extraEnvVars Array with extra environment variables to add to volume permissions init container.
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []

## Kubectl InitContainer
## used by Sentinel to update the isMaster label on the Redis(TM) pods
##
kubectl:
  ## Bitnami Kubectl image version
  ## ref: https://hub.docker.com/r/bitnami/kubectl/tags/
  ## @param kubectl.image.registry [default: REGISTRY_NAME] Kubectl image registry
  ## @param kubectl.image.repository [default: REPOSITORY_NAME/kubectl] Kubectl image repository
  ## @skip kubectl.image.tag Kubectl image tag (immutable tags are recommended), by default, using the current version
  ## @param kubectl.image.digest Kubectl image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param kubectl.image.pullPolicy Kubectl image pull policy
  ## @param kubectl.image.pullSecrets Kubectl pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/kubectl
    tag: 1.32.0-debian-12-r0
    digest: ""
    ## Specify a imagePullPolicy
    ## ref: https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images
    ##
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param kubectl.command kubectl command to execute
  ##
  command: ["/opt/bitnami/scripts/kubectl-scripts/update-master-label.sh"]
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param kubectl.containerSecurityContext.enabled Enabled kubectl containers' Security Context
  ## @param kubectl.containerSecurityContext.seLinuxOptions [object,nullable] Set SELinux options in container
  ## @param kubectl.containerSecurityContext.runAsUser Set kubectl containers' Security Context runAsUser
  ## @param kubectl.containerSecurityContext.runAsGroup Set kubectl containers' Security Context runAsGroup
  ## @param kubectl.containerSecurityContext.runAsNonRoot Set kubectl containers' Security Context runAsNonRoot
  ## @param kubectl.containerSecurityContext.allowPrivilegeEscalation Set kubectl containers' Security Context allowPrivilegeEscalation
  ## @param kubectl.containerSecurityContext.readOnlyRootFilesystem Set container's Security Context read-only root filesystem
  ## @param kubectl.containerSecurityContext.seccompProfile.type Set kubectl containers' Security Context seccompProfile
  ## @param kubectl.containerSecurityContext.capabilities.drop Set kubectl containers' Security Context capabilities to drop
  ##
  containerSecurityContext:
    enabled: true
    seLinuxOptions: {}
    runAsUser: 1001
    runAsGroup: 1001
    runAsNonRoot: true
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    seccompProfile:
      type: RuntimeDefault
    capabilities:
      drop: ["ALL"]
  ## Bitnami Kubectl resource requests and limits
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ## @param kubectl.resources.limits The resources limits for the kubectl containers
  ## @param kubectl.resources.requests The requested resources for the kubectl containers
  ##
  resources:
    limits: {}
    requests: {}

## init-sysctl container parameters
## used to perform sysctl operation to modify Kernel settings (needed sometimes to avoid warnings)
##
sysctl:
  ## @param sysctl.enabled Enable init container to modify Kernel settings
  ##
  enabled: false
  ## OS Shell + Utility image
  ## ref: https://hub.docker.com/r/bitnami/os-shell/tags/
  ## @param sysctl.image.registry [default: REGISTRY_NAME] OS Shell + Utility image registry
  ## @param sysctl.image.repository [default: REPOSITORY_NAME/os-shell] OS Shell + Utility image repository
  ## @skip sysctl.image.tag OS Shell + Utility image tag (immutable tags are recommended)
  ## @param sysctl.image.digest OS Shell + Utility image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param sysctl.image.pullPolicy OS Shell + Utility image pull policy
  ## @param sysctl.image.pullSecrets OS Shell + Utility image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/os-shell
    tag: 12-debian-12-r34
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param sysctl.command Override default init-sysctl container command (useful when using custom images)
  ##
  command: []
  ## @param sysctl.mountHostSys Mount the host `/sys` folder to `/host-sys`
  ##
  mountHostSys: false
  ## Init container's resource requests and limits
  ## ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
  ## @param sysctl.resourcesPreset Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if sysctl.resources is set (sysctl.resources is recommended for production).
  ## More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15
  ##
  resourcesPreset: "nano"
  ## @param sysctl.resources Set container requests and limits for different resources like CPU or memory (essential for production workloads)
  ## Example:
  ## resources:
  ##   requests:
  ##     cpu: 2
  ##     memory: 512Mi
  ##   limits:
  ##     cpu: 3
  ##     memory: 1024Mi
  ##
  resources: {}
## @section useExternalDNS Parameters
##
## @param useExternalDNS.enabled Enable various syntax that would enable external-dns to work.  Note this requires a working installation of `external-dns` to be usable.
## @param useExternalDNS.additionalAnnotations Extra annotations to be utilized when `external-dns` is enabled.
## @param useExternalDNS.annotationKey The annotation key utilized when `external-dns` is enabled. Setting this to `false` will disable annotations.
## @param useExternalDNS.suffix The DNS suffix utilized when `external-dns` is enabled.  Note that we prepend the suffix with the full name of the release.
##
useExternalDNS:
  enabled: false
  suffix: ""
  annotationKey: external-dns.alpha.kubernetes.io/
  additionalAnnotations: {}

{{- end}}