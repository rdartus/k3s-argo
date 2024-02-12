{{- define "helmValues.velero"}} 

##
## Configuration settings related to Velero installation namespace
##

# Labels settings in namespace
namespace:
  labels: {}
    # Enforce Pod Security Standards with Namespace Labels
    # https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/
    # - key: pod-security.kubernetes.io/enforce
    #   value: privileged
    # - key: pod-security.kubernetes.io/enforce-version
    #   value: latest
    # - key: pod-security.kubernetes.io/audit
    #   value: privileged
    # - key: pod-security.kubernetes.io/audit-version
    #   value: latest
    # - key: pod-security.kubernetes.io/warn
    #   value: privileged
    # - key: pod-security.kubernetes.io/warn-version
    #   value: latest

##
## End of namespace-related settings.
##


##
## Configuration settings that directly affect the Velero deployment YAML.
##

# Details of the container image to use in the Velero deployment & daemonset (if
# enabling node-agent). Required.
image:
  repository: velero/velero
  tag: v1.13.0
  # Digest value example: sha256:d238835e151cec91c6a811fe3a89a66d3231d9f64d09e5f3c49552672d271f38.
  # If used, it will take precedence over the image.tag.
  # digest:
  pullPolicy: IfNotPresent
  # One or more secrets to be used when pulling images
  imagePullSecrets: []
  # - registrySecretName

nameOverride: ""
fullnameOverride: ""

# Annotations to add to the Velero deployment's. Optional.
#
# If you are using reloader use the following annotation with your VELERO_SECRET_NAME
annotations: {}
# secret.reloader.stakater.com/reload: "<VELERO_SECRET_NAME>"

# Annotations to add to secret
secretAnnotations: {}

# Labels to add to the Velero deployment's. Optional.
labels: {}

# Annotations to add to the Velero deployment's pod template. Optional.
#
# If using kube2iam or kiam, use the following annotation with your AWS_ACCOUNT_ID
# and VELERO_ROLE_NAME filled in:
podAnnotations: {}
  #  iam.amazonaws.com/role: "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<VELERO_ROLE_NAME>"

# Additional pod labels for Velero deployment's template. Optional
# ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
podLabels: {}

# Number of old history to retain to allow rollback (If not set, default Kubernetes value is set to 10)
# revisionHistoryLimit: 1

# Resource requests/limits to specify for the Velero deployment.
# https://velero.io/docs/v1.6/customize-installation/#customize-resource-requests-and-limits
resources:
  requests:
    cpu: 500m
    memory: 128Mi
  limits:
    cpu: 1000m
    memory: 512Mi

# Resource requests/limits to specify for the upgradeCRDs job pod. Need to be adjusted by user accordingly.
upgradeJobResources: {}
# requests:
#     cpu: 50m
#     memory: 128Mi
#   limits:
#     cpu: 100m
#     memory: 256Mi
upgradeCRDsJob:
  # Extra volumes for the Upgrade CRDs Job. Optional.
  extraVolumes: []
  # Extra volumeMounts for the Upgrade CRDs Job. Optional.
  extraVolumeMounts: []
  # Extra key/value pairs to be used as environment variables. Optional.
  extraEnvVars: {}


# Configure the dnsPolicy of the Velero deployment
# See: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy
dnsPolicy: ClusterFirst

# Init containers to add to the Velero deployment's pod spec. At least one plugin provider image is required.
# If the value is a string then it is evaluated as a template.
initContainers:
  # - name: velero-plugin-for-csi
  #   image: velero/velero-plugin-for-csi:v0.7.0
  #   imagePullPolicy: IfNotPresent
  #   volumeMounts:
  #     - mountPath: /target
  #       name: plugins
  # - name: velero-plugin-for-aws
  #   image: velero/velero-plugin-for-aws:v1.9.0
  #   imagePullPolicy: IfNotPresent
  #   volumeMounts:
  #     - mountPath: /target
  #       name: plugins

# SecurityContext to use for the Velero deployment. Optional.
# Set fsGroup for `AWS IAM Roles for Service Accounts`
# see more informations at: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
podSecurityContext: {}
  # fsGroup: 1337

# Container Level Security Context for the 'velero' container of the Velero deployment. Optional.
# See: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
containerSecurityContext: {}
  # allowPrivilegeEscalation: false
  # capabilities:
  #   drop: ["ALL"]
  #   add: []
  # readOnlyRootFilesystem: true

# Container Lifecycle Hooks to use for the Velero deployment. Optional.
lifecycle: {}

# Pod priority class name to use for the Velero deployment. Optional.
priorityClassName: ""

# The number of seconds to allow for graceful termination of the pod. Optional.
terminationGracePeriodSeconds: 3600

# Liveness probe of the pod
livenessProbe:
  httpGet:
    path: /metrics
    port: http-monitoring
    scheme: HTTP
  initialDelaySeconds: 10
  periodSeconds: 30
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 5

# Readiness probe of the pod
readinessProbe:
  httpGet:
    path: /metrics
    port: http-monitoring
    scheme: HTTP
  initialDelaySeconds: 10
  periodSeconds: 30
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 5

# Tolerations to use for the Velero deployment. Optional.
tolerations: []

# Affinity to use for the Velero deployment. Optional.
affinity: {}

# Node selector to use for the Velero deployment. Optional.
nodeSelector: {}

# DNS configuration to use for the Velero deployment. Optional.
dnsConfig: {}

# Extra volumes for the Velero deployment. Optional.
extraVolumes: []

# Extra volumeMounts for the Velero deployment. Optional.
extraVolumeMounts: []

# Extra K8s manifests to deploy
extraObjects: []
  # - apiVersion: secrets-store.csi.x-k8s.io/v1
  #   kind: SecretProviderClass
  #   metadata:
  #     name: velero-secrets-store
  #   spec:
  #     provider: aws
  #     parameters:
  #       objects: |
  #         - objectName: "velero"
  #           objectType: "secretsmanager"
  #           jmesPath:
  #               - path: "access_key"
  #                 objectAlias: "access_key"
  #               - path: "secret_key"
  #                 objectAlias: "secret_key"
  #     secretObjects:
  #       - data:
  #         - key: access_key
  #           objectName: client-id
  #         - key: client-secret
  #           objectName: client-secret
  #         secretName: velero-secrets-store
  #         type: Opaque

# Settings for Velero's prometheus metrics. Enabled by default.
metrics:
  enabled: true
  scrapeInterval: 30s
  scrapeTimeout: 10s

  # service metdata if metrics are enabled
  service:
    annotations: {}
    labels: {}

  # Pod annotations for Prometheus
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8085"
    prometheus.io/path: "/metrics"

  serviceMonitor:
    autodetect: true
    enabled: false
    annotations: {}
    additionalLabels: {}

    # metrics.serviceMonitor.metricRelabelings Specify Metric Relabelings to add to the scrape endpoint
    # ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#relabelconfig
    # metricRelabelings: []
    # metrics.serviceMonitor.relabelings [array] Prometheus relabeling rules
    # relabelings: []
    # ServiceMonitor namespace. Default to Velero namespace.
    # namespace:
    # ServiceMonitor connection scheme. Defaults to HTTP.
    # scheme: ""
    # ServiceMonitor connection tlsConfig. Defaults to {}.
    # tlsConfig: {}
  nodeAgentPodMonitor:
    autodetect: true
    enabled: false
    annotations: {}
    additionalLabels: {}
    # ServiceMonitor namespace. Default to Velero namespace.
    # namespace:
    # ServiceMonitor connection scheme. Defaults to HTTP.
    # scheme: ""
    # ServiceMonitor connection tlsConfig. Defaults to {}.
    # tlsConfig: {}

  prometheusRule:
    autodetect: true
    enabled: false
    # Additional labels to add to deployed PrometheusRule
    additionalLabels: {}
    # PrometheusRule namespace. Defaults to Velero namespace.
    # namespace: ""
    # Rules to be deployed
    spec: []
    # - alert: VeleroBackupPartialFailures
    #   annotations:
    #     message: Velero backup *- $labels.schedule -* has *- $value | humanizePercentage -* partialy failed backups.
    #   expr: |-
    #     velero_backup_partial_failure_total{schedule!=""} / velero_backup_attempt_total{schedule!=""} > 0.25
    #   for: 15m
    #   labels:
    #     severity: warning
    # - alert: VeleroBackupFailures
    #   annotations:
    #     message: Velero backup *- $labels.schedule -* has *- $value | humanizePercentage -* failed backups.
    #   expr: |-
    #     velero_backup_failure_total{schedule!=""} / velero_backup_attempt_total{schedule!=""} > 0.25
    #   for: 15m
    #   labels:
    #     severity: warning

kubectl:
  image:
    repository: docker.io/bitnami/kubectl
    # Digest value example: sha256:d238835e151cec91c6a811fe3a89a66d3231d9f64d09e5f3c49552672d271f38.
    # If used, it will take precedence over the kubectl.image.tag.
    # digest:
    # kubectl image tag. If used, it will take precedence over the cluster Kubernetes version.
    # tag: 1.16.15
  # Container Level Security Context for the 'kubectl' container of the crd jobs. Optional.
  # See: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  containerSecurityContext: {}
  # Resource requests/limits to specify for the upgrade/cleanup job. Optional
  resources: {}
  # Annotations to set for the upgrade/cleanup job. Optional.
  annotations: {}
  # Labels to set for the upgrade/cleanup job. Optional.
  labels: {}

# This job upgrades the CRDs.
upgradeCRDs: true

# This job is meant primarily for cleaning up CRDs on CI systems.
# Using this on production systems, especially those that have multiple releases of Velero, will be destructive.
cleanUpCRDs: false

##
## End of deployment-related settings.
##


##
## Parameters for the `default` BackupStorageLocation and VolumeSnapshotLocation,
## and additional server settings.
##
configuration:
  # Parameters for the BackupStorageLocation(s). Configure multiple by adding other element(s) to the backupStorageLocation slice.
  # See https://velero.io/docs/v1.6/api-types/backupstoragelocation/
  backupStorageLocation:
    # name is the name of the backup storage location where backups should be stored. If a name is not provided,
    # a backup storage location will be created with the name "default". Optional.
  - name: default
    # provider is the name for the backup storage location provider.
    provider: aws
    # bucket is the name of the bucket to store backups in. Required.
    bucket: jeanstore
    # caCert defines a base64 encoded CA bundle to use when verifying TLS connections to the provider. Optional.
    caCert:
    # prefix is the directory under which all Velero data should be stored within the bucket. Optional.
    prefix:
    # default indicates this location is the default backup storage location. Optional.
    default: true
    # validationFrequency defines how frequently Velero should validate the object storage. Optional.
    validationFrequency:
    # accessMode determines if velero can write to this backup storage location. Optional.
    # default to ReadWrite, ReadOnly is used during migrations and restores.
    accessMode: ReadWrite
    credential:
      # name of the secret used by this backupStorageLocation.
      name: s3-secret
      # name of key that contains the secret data to be used.
      key: access_key
    # Additional provider-specific configuration. See link above
    # for details of required/optional fields for your provider.
    config:
     region: eu-west-3
    #  s3ForcePathStyle:
    #  s3Url:
    #  kmsKeyId:
    #  resourceGroup:
    #  The ID of the subscription containing the storage account, if different from the cluster’s subscription. (Azure only)
    #  subscriptionId:
    #  storageAccount:
    #  publicUrl:
    #  Name of the GCP service account to use for this backup storage location. Specify the
    #  service account here if you want to use workload identity instead of providing the key file.(GCP only)
    #  serviceAccount:
    #  Option to skip certificate validation or not if insecureSkipTLSVerify is set to be true, the client side should set the
    #  flag. For Velero client Command like velero backup describe, velero backup logs needs to add the flag --insecure-skip-tls-verify
    #  insecureSkipTLSVerify:

  # Parameters for the VolumeSnapshotLocation(s). Configure multiple by adding other element(s) to the volumeSnapshotLocation slice.
  # See https://velero.io/docs/v1.6/api-types/volumesnapshotlocation/
  volumeSnapshotLocation:
    # name is the name of the volume snapshot location where snapshots are being taken. Required.
  - name: default
    # provider is the name for the volume snapshot provider.
  #    region:
  #    apiTimeout:
  #    resourceGroup:
  #    The ID of the subscription where volume snapshots should be stored, if different from the cluster’s subscription. If specified, also requires `configuration.volumeSnapshotLocation.config.resourceGroup`to be set. (Azure only)
  #    subscriptionId:
  #    incremental:
  #    snapshotLocation:
  #    project:

  # These are server-level settings passed as CLI flags to the `velero server` command. Velero
  # uses default values if they're not passed in, so they only need to be explicitly specified
  # here if using a non-default value. The `velero server` default values are shown in the
  # comments below.
  # --------------------
  # `velero server` default: restic
  uploaderType:
  # `velero server` default: 1m
  backupSyncPeriod:
  # `velero server` default: 4h
  fsBackupTimeout:
  # `velero server` default: 30
  clientBurst:
  # `velero server` default: 500
  clientPageSize:
  # `velero server` default: 20.0
  clientQPS:
  # Name of the default backup storage location. Default: default
  defaultBackupStorageLocation: amazon-s3-storagelocation
  # How long to wait by default before backups can be garbage collected. Default: 72h
  defaultBackupTTL:
  # Name of the default volume snapshot location.
  defaultVolumeSnapshotLocations: amazon-s3-snapshotlocation
  # `velero server` default: empty
  disableControllers:
  # `velero server` default: 1h
  garbageCollectionFrequency:
  # Set log-format for Velero pod. Default: text. Other option: json.
  logFormat:
  # Set log-level for Velero pod. Default: info. Other options: debug, warning, error, fatal, panic.
  logLevel: debug
  # The address to expose prometheus metrics. Default: :8085
  metricsAddress:
  # Directory containing Velero plugins. Default: /plugins
  pluginDir:
  # The address to expose the pprof profiler. Default: localhost:6060
  profilerAddress:
  # `velero server` default: false
  restoreOnlyMode:
  # `velero server` default: customresourcedefinitions,namespaces,storageclasses,volumesnapshotclass.snapshot.storage.k8s.io,volumesnapshotcontents.snapshot.storage.k8s.io,volumesnapshots.snapshot.storage.k8s.io,persistentvolumes,persistentvolumeclaims,secrets,configmaps,serviceaccounts,limitranges,pods,replicasets.apps,clusterclasses.cluster.x-k8s.io,clusters.cluster.x-k8s.io,clusterresourcesets.addons.cluster.x-k8s.io
  restoreResourcePriorities:
  # `velero server` default: 1m
  storeValidationFrequency:
  # How long to wait on persistent volumes and namespaces to terminate during a restore before timing out. Default: 10m
  terminatingResourceTimeout:
  # Bool flag to configure Velero server to move data by default for all snapshots supporting data movement. Default: false
  defaultSnapshotMoveData:
  # Comma separated list of velero feature flags. default: empty
  # features: EnableCSI
  features: 
  # `velero server` default: velero
  namespace:

  # additional key/value pairs to be used as environment variables such as "AWS_CLUSTER_NAME: 'yourcluster.domain.tld'"
  extraEnvVars: {}

  # Set true for backup all pod volumes without having to apply annotation on the pod when used file system backup Default: false.
  defaultVolumesToFsBackup:

  # How often repository maintain is run for repositories by default.
  defaultRepoMaintainFrequency:

##
## End of backup/snapshot location settings.
##


##
## Settings for additional Velero resources.
##

rbac:
  # Whether to create the Velero role and role binding to give all permissions to the namespace to Velero.
  create: true
  # Whether to create the cluster role binding to give administrator permissions to Velero
  clusterAdministrator: true
  # Name of the ClusterRole.
  clusterAdministratorName: cluster-admin

# Information about the Kubernetes service account Velero uses.
serviceAccount:
  server:
    create: true
    name:
    annotations:
    labels:

# Info about the secret to be used by the Velero deployment, which
# should contain credentials for the cloud provider IAM account you've
# set up for Velero.
credentials:
  # Whether a secret should be used. Set to false if, for examples:
  # - using kube2iam or kiam to provide AWS IAM credentials instead of providing the key file. (AWS only)
  # - using workload identity instead of providing the key file. (Azure/GCP only)
  useSecret: true
  # Name of the secret to create if `useSecret` is true and `existingSecret` is empty
  name:
  # Name of a pre-existing secret (if any) in the Velero namespace
  # that should be used to get IAM account credentials. Optional.
  existingSecret:
  # Data to be stored in the Velero secret, if `useSecret` is true and `existingSecret` is empty.
  # As of the current Velero release, Velero only uses one secret key/value at a time.
  # The key must be named `cloud`, and the value corresponds to the entire content of your IAM credentials file.
  # Note that the format will be different for different providers, please check their documentation.
  # Here is a list of documentation for plugins maintained by the Velero team:
  # [AWS] https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/main/README.md
  # [GCP] https://github.com/vmware-tanzu/velero-plugin-for-gcp/blob/main/README.md
  # [Azure] https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure/blob/main/README.md
  secretContents: {}
  #  cloud: |
  #    [default]
  #    aws_access_key_id=<REDACTED>
  #    aws_secret_access_key=<REDACTED>
  # additional key/value pairs to be used as environment variables such as "DIGITALOCEAN_TOKEN: <your-key>". Values will be stored in the secret.
  extraEnvVars: {}
  # Name of a pre-existing secret (if any) in the Velero namespace
  # that will be used to load environment variables into velero and node-agent.
  # Secret should be in format - https://kubernetes.io/docs/concepts/configuration/secret/#use-case-as-container-environment-variables
  extraSecretRef: ""

# Whether to create backupstoragelocation crd, if false => do not create a default backup location
backupsEnabled: true
# Whether to create volumesnapshotlocation crd, if false => disable snapshot feature
snapshotsEnabled: true

# Whether to deploy the node-agent daemonset.
deployNodeAgent: false

nodeAgent:
  podVolumePath: /var/lib/kubelet/pods
  privileged: false
  # Pod priority class name to use for the node-agent daemonset. Optional.
  priorityClassName: ""
  # Resource requests/limits to specify for the node-agent daemonset deployment. Optional.
  # https://velero.io/docs/v1.6/customize-installation/#customize-resource-requests-and-limits
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 1000m
      memory: 1024Mi

  # Tolerations to use for the node-agent daemonset. Optional.
  tolerations: []

  # Annotations to set for the node-agent daemonset. Optional.
  annotations: {}

  # labels to set for the node-agent daemonset. Optional.
  labels: {}

  # will map /scratch to emptyDir. Set to false and specify your own volume
  # via extraVolumes and extraVolumeMounts that maps to /scratch
  # if you don't want to use emptyDir.
  useScratchEmptyDir: true

  # Extra volumes for the node-agent daemonset. Optional.
  extraVolumes: []

  # Extra volumeMounts for the node-agent daemonset. Optional.
  extraVolumeMounts: []

  # Key/value pairs to be used as environment variables for the node-agent daemonset. Optional.
  extraEnvVars: {}

  # Configure the dnsPolicy of the node-agent daemonset
  # See: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy
  dnsPolicy: ClusterFirst

  # SecurityContext to use for the Velero deployment. Optional.
  # Set fsGroup for `AWS IAM Roles for Service Accounts`
  # see more informations at: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
  podSecurityContext:
    runAsUser: 0
    # fsGroup: 1337

  # Container Level Security Context for the 'node-agent' container of the node-agent daemonset. Optional.
  # See: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  containerSecurityContext: {}

  # Container Lifecycle Hooks to use for the node-agent daemonset. Optional.
  lifecycle: {}

  # Node selector to use for the node-agent daemonset. Optional.
  nodeSelector: {}

  # Affinity to use with node-agent daemonset. Optional.
  affinity: {}

  # DNS configuration to use for the node-agent daemonset. Optional.
  dnsConfig: {}

# Backup schedules to create.
# Eg:
# schedules:
#   mybackup:
#     disabled: false
#     labels:
#       myenv: foo
#     annotations:
#       myenv: foo
#     schedule: "0 0 * * *"
#     useOwnerReferencesInBackup: false
#     template:
#       ttl: "240h"
#       storageLocation: default
#       includedNamespaces:
#       - foo
schedules: {}

# Velero ConfigMaps.
# Eg:
# configMaps:
    # See: https://velero.io/docs/v1.11/file-system-backup/
#   fs-restore-action-config:
#     labels:
#       velero.io/plugin-config: ""
#       velero.io/pod-volume-restore: RestoreItemAction
#     data:
#       image: velero/velero-restore-helper:v1.10.2
#       cpuRequest: 200m
#       memRequest: 128Mi
#       cpuLimit: 200m
#       memLimit: 128Mi
#       secCtx: |
#         capabilities:
#           drop:
#           - ALL
#           add: []
#         allowPrivilegeEscalation: false
#         readOnlyRootFilesystem: true
#         runAsUser: 1001
#         runAsGroup: 999
configMaps: {}

##
## End of additional Velero resource settings.
##

{{- end}}