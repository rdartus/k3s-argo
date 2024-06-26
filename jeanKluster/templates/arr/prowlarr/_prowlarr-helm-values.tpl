{{- define "helmValues.prowlarr" }}

{{-  $dbServiceName := printf "%s.%s.svc.cluster.local" .Values.db.appName .Values.db.namespace -}}
#
# IMPORTANT NOTE
#
# This chart inherits from our common library chart. You can check the default values/options here:
# https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml
#

image:
  # -- image repository
  repository: ghcr.io/onedr0p/prowlarr
  # @default -- chart.appVersion
  tag: rolling
  # -- image pull policy
  pullPolicy: IfNotPresent

# -- environment variables.
# @default -- See below
env:
  # -- Set the container timezone
  TZ: UTC
  PROWLARR__AUTHENTICATION_METHOD: "External"
  PROWLARR__POSTGRES_HOST: {{ $dbServiceName }}
  PROWLARR__POSTGRES_MAIN_DB: 'prowlarr-main'
  PROWLARR__POSTGRES_LOG_DB: 'prowlarr-log'
  PROWLARR__POSTGRES_USER:
    valueFrom:
      secretKeyRef:
        name: arr-secret
        key: username
  PROWLARR__POSTGRES_PASSWORD: 
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
        port: 9696


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
        host: prowlarr.dartus.fr
        ## Configure the paths for the host
        paths:
          -  # -- Path.  Helm template can be passed.
            path: /
            # -- Ignored if not kubeVersion >= 1.14-0
            pathType: Prefix


# -- Configure persistence settings for the chart under this key.
# @default -- See values.yaml
persistence:
  config:
    enabled: false
  media:
    enabled: true
    type : pvc
    existingClaim: pvc-dl
    size: 200Mi

{{- end }}
