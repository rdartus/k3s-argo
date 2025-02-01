{{- define "helmValues.hajimari" }}

#
# IMPORTANT NOTE
#
# This chart inherits from the bjw-s library chart. You can check the default values/options here:
# https://github.com/bjw-s/helm-charts/tree/main/charts/library/common
#

controllers:
  main:
    containers:
      main:
        image:
          # -- image repository
          repository: ghcr.io/toboshii/hajimari
          # -- image pull policy
          pullPolicy: IfNotPresent
          # -- image tag
          tag: v0.3.1

# -- environment variables.
# @default -- See below
env:
  # -- Set the container timezone
  TZ: UTC

# -- Configures Hajimari settings for this instance.
# @default -- See below
hajimari:
  defaultEnable: false
  namespaceSelector:
    matchNames:
    - default
    - argocd
    - podinfo
    - jeanpi
    
  title: "test title"
  name: "Chacal"
  lightTheme: Paper
  darkTheme: horizon
  showAppGroups: true

  customApps: 
  - group: Hallais
    apps:
      - name: AnaNAS
        group: 'Hallais-Corp'
        url: 'https://ananas-ext.synology.me:5001'
        icon: 'fruit-pineapple'
        info: 'NAS'

  alwaysTargetBlank: true
  createCRAppSample: false
  defaultSearchProvider: Google
  defaultAppIcon: mdi:application
  searchProviders:
    - name: Google
      token: g
      icon: simple-icons:google
      searchUrl: https://www.google.com/search?q={query}
      url: https://www.google.com
    - name: DuckDuckGo
      token: d
      icon: simple-icons:duckduckgo
      searchUrl: https://duckduckgo.com/?q={query}
      url: https://duckduckgo.com
    - name: IMDB
      token: i
      icon: simple-icons:imdb
      searchUrl: https://www.imdb.com/find?q={query}
      url: https://www.imdb.com
    - name: Reddit
      token: r
      icon: simple-icons:reddit
      searchUrl: https://www.reddit.com/search?q={query}
      url: https://www.reddit.com
    - name: YouTube
      token: 'y'
      icon: simple-icons:youtube
      searchUrl: https://www.youtube.com/results?search_query={query}
      url: https://www.youtube.com
    - name: Spotify
      token: s
      icon: simple-icons:spotify
      searchUrl: hhttps://open.spotify.com/search/{query}
      url: https://open.spotify.com

# -- Configures service settings for the chart.
# @default -- See values.yaml
service:
  main:
    ports:
      http:
        port: 3000

# -- Configures service account needed for reading k8s ingress objects
# @default -- See below
serviceAccount:
  # -- Create service account
  create: true

ingress:
  main:
    # -- Enables or disables the ingress
    enabled: true

    # -- Override the name suffix that is used for this ingress.
    nameOverride:

    # -- Provide additional annotations which may be required.
    annotations:
      hajimari.io/enable: "true"
      hajimari.io/group: "Home"
      hajimari.io/icon: "cog-play-outline"
      cert-manager.io/cluster-issuer: {{ .Values.clusterIssuer }}

    # -- Provide additional labels which may be required.
    labels: {}

    # -- Set the ingressClass that is used for this ingress.
    className: "traefik-ingresses"

    # -- Configure the defaultBackend for this ingress. This will disable any other rules for the ingress.
    # defaultBackend: '{"service": {"name": "hajimari","port": {"number": 3000}}}'

persistence:
  config:
    enabled: true
    type: configMap
    name: hajimari-settings

{{- end }}
