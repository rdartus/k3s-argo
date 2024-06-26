{{- define "helmValues.sonarr" }}

{{-  $dbServiceName := printf "%s.%s.svc.cluster.local" .Values.db.appName .Values.db.namespace -}}

#
# IMPORTANT NOTE
#
# This chart inherits from our common library chart. You can check the default values/options here:
# https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml
#

image:
  # -- image repository
  repository: ghcr.io/onedr0p/sonarr
  # @default -- chart.appVersion
  tag: rolling
  # -- image pull policy
  pullPolicy: IfNotPresent

# -- environment variables.
# @default -- See below
env:
  # -- Set the container timezone
  TZ: UTC
  SONARR__AUTHENTICATION_METHOD: "External"
  SONARR__POSTGRES_HOST: {{ $dbServiceName }}
  SONARR__POSTGRES_MAIN_DB: 'sonarr-main'
  SONARR__POSTGRES_LOG_DB: 'sonarr-log'
  SONARR__POSTGRES_USER:
    valueFrom:
      secretKeyRef:
        name: arr-secret
        key: username
  SONARR__POSTGRES_PASSWORD:
    valueFrom:
      secretKeyRef:
        name: arr-secret
        key: password

# -- Configures service settings for the chart.
# @default -- See values.yaml
service:
  main:
    ports:
      http:
        port: 8989

ingress:
  # -- Enable and configure ingress settings for the chart under this key.
  # @default -- See values.yaml

  main:
    annotations:
      hajimari.io/enable: "true"
      hajimari.io/group: "Media"
      hajimari.io/icon: "cog-play-outline"
    enabled: true
    hosts:
      -  # -- Host address. Helm template can be passed.
        host: sonarr2.dartus.fr
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
        - curl --fail localhost:8989/api/v3/system/status?apiKey=`IFS=\> && while
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
  config:
    enabled: false

  media:
    enabled: true
    type : pvc
    existingClaim: pvc-series
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
      # - alert: SonarrDown
      #   annotations:
      #     description: Sonarr service is down.
      #     summary: Sonarr is down.
      #   expr: |
      #     sonarr_system_status == 0
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
      port: 9794
      # -- Set to true to enable gathering of additional metrics (slow)
      additionalMetrics: false
      # -- Set to true to enable gathering unknown queue items
      unknownQueueItems: false
{{- end }}
