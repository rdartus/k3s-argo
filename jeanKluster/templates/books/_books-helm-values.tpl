{{- define "helmValues.books" }}

#
# IMPORTANT NOTE
#
# This chart inherits from our common library chart. You can check the default values/options here:
# https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml
#

image:
  # -- image repository
  repository: ghcr.io/linuxserver/calibre-web
  # -- image tag
  tag: latest
  # -- image pull policy
  pullPolicy: IfNotPresent

# -- environment variables. See more environment variables in the [calibre-web documentation](https://github.com/linuxserver/docker-calibre-web#parameters).
# @default -- See below
env:
  # -- Set the container timezone
  TZ: UTC
  # -- Specify the user ID the application will run as
  PUID: "1001"
  # -- Specify the group ID the application will run as
  PGID: "1001"

# -- Configures service settings for the chart.
# @default -- See values.yaml
service:
  main:
    ports:
      http:
        port: 8083

ingress:
  # -- Enable and configure ingress settings for the chart under this key.
  # @default -- See values.yaml

  main:
    enabled: true
    annotations:
      hajimari.io/enable: "true"
      hajimari.io/group: "Media"
      hajimari.io/icon: "bookshelf"
      hajimari.io/appName: "livres"
    hosts:
      -  # -- Host address. Helm template can be passed.
        host: books2.dartus.fr
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
    enabled: true
    type : pvc
    existingClaim: pvc-books-conf2
    size: 200Mi
  books:
    enabled: true
    type : pvc
    existingClaim: pvc-books
    size: 200Mi
{{- end }}
