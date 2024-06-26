{{- define "helmValues.radarr" }}

{{-  $dbServiceName := printf "%s.%s.svc.cluster.local" .Values.db.appName .Values.db.namespace -}}

configmap:
  test:
    # -- Enables or disables the configMap
    enabled: true
    # -- Labels to add to the configMap
    labels: {}
    # -- Annotations to add to the configMap
    annotations: {}
    # -- configMap data content. Helm template enabled.
    data: 
      foo: bar

  test2:
    enabled: true
    data:
      config.yaml: |

        # -- The name of this instance, this allows running multiple 
        # instances of Hajimari on the same cluster
        instanceName: null

        # -- Set to true to show all discovered applications by default.
        defaultEnable: false

        # -- Namespace selector to use for discovering applications
        namespaceSelector:
          matchNames:
          - media
          
        # -- Override the title of the Hajimari pages
        title: null

        # -- Default name for welcome message
        name: "Satan 2"

        # -- Add custom applications to the discovered application list
        customApps: []
        # - group: Media
        #   apps:
        #     - name: Test
        #       url: 'https://example.com'
        #       icon: 'mdi:test-tube'
        #       info: This is a test app

# -- Create sample Custom Resource Application
createCRAppSample: false

# -- Set default bookmarks
globalBookmarks: []

# - group: Communicate
#   bookmarks:
#   - name: Discord
#     url: 'https://discord.com'
#   - name: Gmail
#     url: 'http://gmail.com'
#   - name: Slack
#     url: 'https://slack.com/signin'

#
# IMPORTANT NOTE
#
# This chart inherits from our common library chart. You can check the default values/options here:
# https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml
#

image:
  # -- image repository
  repository: ghcr.io/onedr0p/radarr
  # @default -- chart.appVersion
  tag: rolling
  # -- image pull policy
  pullPolicy: IfNotPresent

# -- environment variables.
# @default -- See below
env:
  # -- Set the container timezone
  TZ: UTC
  # RADARR__ANALYTICS_ENABLED: 'False'
  # RADARR__API_KEY: ''
  RADARR__AUTHENTICATION_METHOD: "External"
  # RADARR__AUTHENTICATION_REQUIRED: ''
  # RADARR__BRANCH: '(current channel)'
  # RADARR__INSTANCE_NAME: 'Radarr'
  # RADARR__LOG_LEVEL: 'info'
  # RADARR__PORT: '7878'
  
  RADARR__POSTGRES_HOST: {{ $dbServiceName }}
  RADARR__POSTGRES_MAIN_DB: 'radarr-main'
  RADARR__POSTGRES_LOG_DB: 'radarr-log'
  RADARR__POSTGRES_USER:
    valueFrom:
      secretKeyRef:
        name: arr-secret
        key: username
  RADARR__POSTGRES_PASSWORD:
    valueFrom:
      secretKeyRef:
        name: arr-secret
        key: password
  # RADARR__POSTGRES_PORT: '5432'
  # RADARR__URL_BASE: ''
# -- Configures service settings for the chart.
# @default -- See values.yaml
service:
  main:
    ports:
      http:
        port: 7878

ingress:
  # -- Enable and configure ingress settings for the chart under this key.
  # @default -- See values.yaml

  main:
    enabled: true
    annotations:
      hajimari.io/enable: "true"
      hajimari.io/group: "Media"
      hajimari.io/icon: "cog-play-outline"
    hosts:
      -  # -- Host address. Helm template can be passed.
        host: radarr2.dartus.fr
        ## Configure the paths for the host
        paths:
          -  # -- Path.  Helm template can be passed.
            path: /
            # -- Ignored if not kubeVersion >= 1.14-0
            pathType: Prefix

# -- Configures the probes for the main Pod.
# @default -- See values.yaml
probes:
  liveness:
    enabled: true
    ## Set this to true if you wish to specify your own livenessProbe
    custom: true
    ## The spec field contains the values for the default livenessProbe.
    ## If you selected custom: true, this field holds the definition of the livenessProbe.
    spec:
      exec:
        command:
        - /usr/bin/env
        - bash
        - -c
        - curl --fail localhost:7878/api/v3/system/status?apiKey=`IFS=\> && while
          read -d \< E C; do if [[ $E = "ApiKey" ]]; then echo $C; fi; done < /config/config.xml`
      failureThreshold: 5
      initialDelaySeconds: 60
      periodSeconds: 10
      successThreshold: 1
      timeoutSeconds: 10

# -- Configure persistence settings for the chart under this key.
## Config persistence is required for the Prometheus exporter sidecar.
# @default -- See values.yaml
persistence:
  test:
    enabled: true
    type: configMap
    name: radarr-test
  test2:
    enabled: true
    type: configMap
    name: radarr-test2

  media:
    enabled: true
    type : pvc
    existingClaim: pvc-films
    size: 200Mi

metrics:
  # -- Enable and configure Exportarr sidecar and Prometheus serviceMonitor.
  # @default -- See values.yaml
  enabled: false
  serviceMonitor:
    interval: 3m
    scrapeTimeout: 1m
    labels: {}
  # -- Enable and configure Prometheus Rules for the chart under this key.
  # @default -- See values.yaml
  prometheusRule:
    enabled: false
    labels: {}
    # -- Configure additionial rules for the chart under this key.
    # @default -- See prometheusrules.yaml
    rules: []
      # - alert: RadarrDown
      #   annotations:
      #     description: Radarr service is down.
      #     summary: Radarr is down.
      #   expr: |
      #     radarr_system_status == 0
      #   for: 5m
      #   labels:
      #     severity: critical
  exporter:
    image:
      # -- image repository
      repository: ghcr.io/onedr0p/exportarr
      # -- image tag
      tag: v1.3.1
      # -- image pull policy
      pullPolicy: IfNotPresent
    env:
      # -- metrics port
      port: 9793
      # -- Set to true to enable gathering of additional metrics (slow)
      additionalMetrics: false
      # -- Set to true to enable gathering unknown queue items
      unknownQueueItems: false

{{- end }}
