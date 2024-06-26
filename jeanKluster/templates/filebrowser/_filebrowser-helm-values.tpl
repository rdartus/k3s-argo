{{- define "helmValues.filebrowser" }}

#
# IMPORTANT NOTE
#
# This chart inherits from our common library chart. You can check the default values/options here:
# https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml
#

image:
  # -- image repository
  repository: filebrowser/filebrowser
  # -- image tag
  tag: v2.18.0
  # -- image pull policy
  pullPolicy: IfNotPresent

# @default -- See below
env:
  # -- Set the container timezone
  TZ: UTC

# -- Configures service settings for the chart.
# @default -- See values.yaml
service:
  main:
    ports:
      http:
        port: 80

ingress:
  # -- Enable and configure ingress settings for the chart under this key.
  # @default -- See values.yaml
  main:
    enabled: false

config: |
  {
    "port": 80,
    "baseURL": "",
    "address": "",
    "log": "stdout",
    "database": "/config/database.db",
    "root": "/srv/data"
  }

# -- Configure persistence settings for the chart under this key.
# @default -- See values.yaml
persistence:
  config:
    enabled: true
    type : pvc
    existingClaim: pvc-filebrowser-conf
    size: 200Mi
  data:
    enabled: true
    type : pvc
    existingClaim: pvc-drive
    size: 200Mi
{{- end }}
