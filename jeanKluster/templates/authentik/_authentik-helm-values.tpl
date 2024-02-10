{{- define "helmValues.authentik" }}

{{-  $dbServiceName := printf "%s.%s.svc.cluster.local" .Values.db.appName .Values.db.namespace -}} 

# -- Server replicas
replicas: 1
# -- Custom priority class for different treatment by the scheduler
priorityClassName:
# -- server securityContext
securityContext: {}
# -- server containerSecurityContext
containerSecurityContext: {}
# -- server deployment strategy
strategy: {}
  # type: RollingUpdate
  # rollingUpdate:
  #  maxSurge: 25%
  #  maxUnavailable: 25%

worker:
  # -- worker replicas
  replicas: 1
  # -- Custom priority class for different treatment by the scheduler
  priorityClassName:
  # -- worker securityContext
  securityContext: {}
  # -- worker containerSecurityContext
  containerSecurityContext: {}
  # -- worker strategy
  strategy: {}
    # type: RollingUpdate
    # rollingUpdate:
    #  maxSurge: 25%
    #  maxUnavailable: 25%

image:
  repository: ghcr.io/goauthentik/server
  tag: 2023.10.7
  # -- optional container image digest
  digest: ""
  pullPolicy: IfNotPresent
  pullSecrets: []

# -- Specify any initContainers here as dictionary items. Each initContainer should have its own key. The dictionary item key will determine the order. Helm templates can be used
initContainers: {}

# -- Specify any additional containers here as dictionary items. Each additional container should have its own key. Helm templates can be used.
additionalContainers: {}

ingress:
  enabled: true
  ingressClassName: "traefik-ingresses"
  annotations: {}
  labels: {}
  hosts:
    - host: authentik.dartus.fr
      paths:
        - path: "/"
          pathType: Prefix
  tls: []

# -- Annotations to add to the server and worker deployments
annotations: {}

# -- Annotations to add to the server and worker pods
podAnnotations: {}

authentik:
  # -- Log level for server and worker
  log_level: debug
  # -- Secret key used for cookie singing and unique user IDs,
  # don't change this after the first install
  secret_key: ""
  # -- Path for the geoip database. If the file doesn't exist, GeoIP features are disabled.
  geoip: /geoip/GeoLite2-City.mmdb
  email:
    # -- SMTP Server emails are sent from, fully optional
    host: ""
    port: 587
    # -- SMTP credentials, when left empty, not authentication will be done
    username: ""
    # -- SMTP credentials, when left empty, not authentication will be done
    password: ""
    # -- Enable either use_tls or use_ssl, they can't be enabled at the same time.
    use_tls: false
    # -- Enable either use_tls or use_ssl, they can't be enabled at the same time.
    use_ssl: false
    # -- Connection timeout
    timeout: 30
    # -- Email from address, can either be in the format "foo@bar.baz" or "authentik <foo@bar.baz>"
    from: ""
  outposts:
    # -- Template used for managed outposts. The following placeholders can be used
    # %(type)s - the type of the outpost
    # %(version)s - version of your authentik install
    # %(build_hash)s - only for beta versions, the build hash of the image
    container_image_base: ghcr.io/goauthentik/%(type)s:%(version)s
  error_reporting:
    # -- This sends anonymous usage-data, stack traces on errors and
    # performance data to sentry.beryju.org, and is fully opt-in
    enabled: false
    # -- This is a string that is sent to sentry with your error reports
    environment: "k8s"
    # -- Send PII (Personally identifiable information) data to sentry
    send_pii: false
  postgresql:
    # -- set the postgresql hostname to talk to
    # if unset and .Values.postgresql.enabled == true, will generate the default
    # @default -- `{{ .Release.Name }}-postgresql`
    host: "{{ .Release.Name }}-postgresql"
    # -- postgresql Database name
    # @default -- `authentik`
    name: "authentik"
    # -- postgresql Username
    # @default -- `authentik`
    user: "authentik"
    password: ""
    port: 5432
  redis:
    # -- set the redis hostname to talk to
    # @default -- `{{ .Release.Name }}-redis-master`
    host: "{{ .Release.Name }}-redis-master"
    password: ""

# -- List of config maps to mount blueprints from. Only keys in the
# configmap ending with ".yaml" wil be discovered and applied
blueprints: []

# -- see configuration options at https://goauthentik.io/docs/installation/configuration/
env:
  AUTHENTIK_POSTGRESQL__NAME: "authentik"
  AUTHENTIK_POSTGRESQL__HOST: "{{ $dbServiceName }}"
  AUTHENTIK_POSTGRESQL__USER: "{{ .Values.db.auth_user }}"
  AUTHENTIK_POSTGRESQL__PASSWORD: "{{ .Values.db.auth_userPass }}"
  AUTHENTIK_REDIS__HOST: "redis-headless.default.svc.cluster.local"
  AUTHENTIK_REDIS__PORT: 6379
  AUTHENTIK_REDIS__PASSWORD: "testredis"
  AUTHENTIK_EMAIL__HOST: smtp.gmail.com
  AUTHENTIK_EMAIL__PORT: 587
  AUTHENTIK_EMAIL__USE_TLS: true
  AUTHENTIK_EMAIL__TIMEOUT: 10
  AUTHENTIK_SECRET_KEY: "PleaseGenerateA50CharKey"
# AUTHENTIK_VAR_NAME: VALUE

envFrom: []
#  - configMapRef:
#      name: special-config

envValueFrom: {}
#  AUTHENTIK_VAR_NAME:
#    secretKeyRef:
#      key: password
#      name: my-secret

service:
  # -- Service that is created to access authentik
  enabled: true
  type: ClusterIP
  port: 80
  name: http
  protocol: TCP
  labels: {}
  annotations: {}

volumes: []

volumeMounts: []

# -- affinity applied to the deployments
affinity: {}

#  -- tolerations applied to the deployments
tolerations: []

# -- nodeSelector applied to the deployments
nodeSelector: {}

resources:
  server: {}
  worker: {}

autoscaling:
  server:
    # -- Create a HPA for the server deployment
    enabled: false
    minReplicas: 1
    maxReplicas: 5
    targetCPUUtilizationPercentage: 50
  worker:
    # -- Create a HPA for the worker deployment
    enabled: false
    minReplicas: 1
    maxReplicas: 5
    targetCPUUtilizationPercentage: 80

pdb:
  server:
    # -- Deploy a PodDistrubtionBudget for the server
    enabled: false
    # -- Labels to be added to the server pdb
    labels: {}
    # -- Annotations to be added to the server pdb
    annotations: {}
    # -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
    # @default -- `""` (defaults to 0 if not specified)
    minAvailable: ""
    # -- Number of pods that are unavailable after eviction as number or percentage (eg.: 50%)
    ## Has higher precedence over `pdb.server.minAvailable`
    maxUnavailable: ""
  worker:
    # -- Deploy a PodDistrubtionBudget for the worker
    enabled: false
    # -- Labels to be added to the worker pdb
    labels: {}
    # -- Annotations to be added to the worker pdb
    annotations: {}
    # -- Number of pods that are available after eviction as number or percentage (eg.: 50%)
    # @default -- `""` (defaults to 0 if not specified)
    minAvailable: ""
    # -- Number of pods that are unavailable after eviction as number or percentage (eg.: 50%)
    ## Has higher precedence over `pdb.worker.minAvailable`
    maxUnavailable: ""

livenessProbe:
  # -- enables or disables the livenessProbe
  enabled: true
  httpGet:
    # -- liveness probe url path
    path: /-/health/live/
    port: http
  initialDelaySeconds: 5
  periodSeconds: 10

startupProbe:
  # -- enables or disables the livenessProbe
  enabled: true
  httpGet:
    # -- liveness probe url path
    path: /-/health/live/
    port: http
  failureThreshold: 60
  periodSeconds: 5

readinessProbe:
  enabled: true
  httpGet:
    path: /-/health/ready/
    port: http
  periodSeconds: 10

serviceAccount:
  # -- Service account is needed for managed outposts
  create: true
  annotations: {}
  serviceAccountSecret:
    # -- As we use the authentik-remote-cluster chart as subchart, and that chart
    # creates a service account secret by default which we don't need here, disable its creation
    enabled: false
  fullnameOverride: authentik
  nameOverride: authentik

prometheus:
  serviceMonitor:
    create: false
    interval: 30s
    scrapeTimeout: 3s
    # -- labels additional on ServiceMonitor
    labels: {}
  rules:
    create: false
    # -- labels additional on PrometheusRule
    labels: {}

geoip:
  # -- optional GeoIP, deploys a cronjob to download the maxmind database
  enabled: false
  # -- sign up under https://www.maxmind.com/en/geolite2/signup
  accountId: ""
  # -- sign up under https://www.maxmind.com/en/geolite2/signup
  licenseKey: ""
  editionIds: "GeoLite2-City"
  image: maxmindinc/geoipupdate:v4.8
  # -- number of hours between update runs
  updateInterval: 8
  # -- server containerSecurityContext
  containerSecurityContext: {}
postgresql:
  # -- enable the bundled bitnami postgresql chart
  enabled: false
  postgresqlMaxConnections: 500
  postgresqlUsername: "authentik"
  # postgresqlPassword: ""
  postgresqlDatabase: "authentik"
  # persistence:
  #   enabled: true
  #   storageClass:
  #   accessModes:
  #     - ReadWriteOnce
  image:
    tag: 15.4.0-debian-11-r0
redis:
  # -- enable the bundled bitnami redis chart
  enabled: false
  architecture: standalone
  auth:
    enabled: false
  image:
    tag: 6.2.10-debian-11-r13
    
{{- end }}