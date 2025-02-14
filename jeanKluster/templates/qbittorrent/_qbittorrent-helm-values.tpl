{{- define "helmValues.qbittorent" }}
#
# IMPORTANT NOTE
#
# This chart inherits from our common library chart. You can check the default values/options here:
# https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml
#
global:
  labels: 
    test: "test"
configmap:
  config:
    # -- Enables or disables the configMap
    enabled: true
    # -- Labels to add to the configMap
    labels: {}
    # -- Annotations to add to the configMap
    annotations: {}
    # -- configMap data content. Helm template enabled.
    data: 
      categories.json: |
        {
          "books": {
              "save_path": ""
          },
          "manga": {
              "save_path": "/data/seed/manga/unlinked"
          },
          "programmes": {
              "save_path": ""
          },
          "prowlarr": {
              "save_path": ""
          },
          "radarr": {
              "save_path": "/data/seed/films/hardlinked"
          },
          "sonarr": {
              "save_path": "/data/seed/series/hardlinked"
          },
          "tmp": {
              "save_path": ""
          }
        }
image:
  # -- image repository
  repository: ghcr.io/onedr0p/qbittorrent
  # @default -- chart.appVersion
  tag: rolling
  # -- image pull policy
  pullPolicy: IfNotPresent

command:
  - /bin/sh
  - -c
  - |
    mkdir -p /config/qBittorrent
    echo $CATEGORIES > /config/qBittorrent/categories.json
    /entrypoint.sh

settings:
  # -- Enables automatic port configuration at startup
  # This sets the qbittorrent port to the value of `service.bittorrent.ports.bittorrent.port`.
  automaticPortSetup: false

# -- environment variables. See [image docs](https://docs.k8s-at-home.com/our-container-images/configuration/) for more details.
# @default -- See below
env:
  # -- Set the container timezone
  TZ: UTC
      
  QBT_Application__FileLogger__Age: '1'
  QBT_Application__FileLogger__AgeType: '1'
  QBT_Application__FileLogger__Backup: 'true'
  QBT_Application__FileLogger__DeleteOld: 'true'
  QBT_Application__FileLogger__Enabled: 'true'
  QBT_Application__FileLogger__MaxSizeBytes: '66560'
  QBT_Application__FileLogger__Path: '/config/qBittorrent/logs'

  QBT_BitTorrent__Session__DefaultSavePath: '/data/tmp'
  QBT_BitTorrent__Session__DisableAutoTMMByDefault: 'false'
  QBT_BitTorrent__Session__ExcludedFileNames: 
  QBT_BitTorrent__Session__GlobalUPSpeedLimit: '10000'
  QBT_BitTorrent__Session__MaxActiveDownloads: '3'
  QBT_BitTorrent__Session__MaxActiveTorrents: '5'
  QBT_BitTorrent__Session__MaxActiveUploads: '3'
  QBT_BitTorrent__Session__Port: '6881'
  QBT_BitTorrent__Session__QueueingSystemEnabled: 'true'
  QBT_BitTorrent__Session__Tags: 'radarr, sonarr, games, manga, manual'
  QBT_BitTorrent__Session__TempPath: '/downloads/incomplete/'

  QBT_Preferences__Advanced__RecheckOnCompletion: 'false'
  QBT_Preferences__Advanced__trackerPort: '9000'
  QBT_Preferences__Advanced__trackerPortForwarding: 'false'
  QBT_Preferences__Connection__PortRangeMin: '6881'
  QBT_Preferences__Connection__ResolvePeerCountries: 'true'
  QBT_Preferences__Connection__UPnP: 'false'
  QBT_Preferences__Downloads__SavePath: '/downloads/'
  QBT_Preferences__Downloads__TempPath: '/downloads/incomplete/'
  QBT_Preferences__DynDNS__DomainName: 'changeme.dyndns.org'
  QBT_Preferences__DynDNS__Enabled: 'false'
  QBT_Preferences__DynDNS__Password: ''
  QBT_Preferences__DynDNS__Service: 'DynDNS'
  QBT_Preferences__DynDNS__Username: ''
  QBT_Preferences__General__Locale: 'en'
  QBT_Preferences__MailNotification__email: ''
  QBT_Preferences__MailNotification__enabled: 'false'
  QBT_Preferences__MailNotification__password: ''
  QBT_Preferences__MailNotification__req_auth: 'true'
  QBT_Preferences__MailNotification__req_ssl: 'false'
  QBT_Preferences__MailNotification__sender: 'qBittorrent_notification@example.com'
  QBT_Preferences__MailNotification__smtp_server: 'smtp.changeme.com'
  QBT_Preferences__MailNotification__username: ''
  QBT_Preferences__WebUI__Address: '*'
  QBT_Preferences__WebUI__AlternativeUIEnabled: 'false'
  QBT_Preferences__WebUI__AuthSubnetWhitelist: '172.18.0.0/16, 192.168.0.0/16, 10.42.0.0/16, 10.41.0.0/16'
  QBT_Preferences__WebUI__AuthSubnetWhitelistEnabled: 'true'
  QBT_Preferences__WebUI__BanDuration: '3600'
  QBT_Preferences__WebUI__CSRFProtection: 'true'
  QBT_Preferences__WebUI__ClickjackingProtection: 'true'
  QBT_Preferences__WebUI__CustomHTTPHeaders: ''
  QBT_Preferences__WebUI__CustomHTTPHeadersEnabled: 'false'
  QBT_Preferences__WebUI__HTTPS__CertificatePath: ''
  QBT_Preferences__WebUI__HTTPS__Enabled: 'false'
  QBT_Preferences__WebUI__HTTPS__KeyPath: ''
  QBT_Preferences__WebUI__HostHeaderValidation: 'false'
  QBT_Preferences__WebUI__LocalHostAuth: 'false'
  QBT_Preferences__WebUI__MaxAuthenticationFailCount: '5'
  QBT_Preferences__WebUI__Port: '8080'
  QBT_Preferences__WebUI__ReverseProxySupportEnabled: 'true'
  QBT_Preferences__WebUI__RootFolder: ''
  QBT_Preferences__WebUI__SecureCookie: 'true'
  QBT_Preferences__WebUI__ServerDomains: '*'
  QBT_Preferences__WebUI__SessionTimeout: '3600'
  QBT_Preferences__WebUI__TrustedReverseProxiesList: 'traefik'
  QBT_Preferences__WebUI__UseUPnP: 'false'
  QBT_Preferences__WebUI__Username: 'admin'
  QBT_Preferences__WebUI__Password_PBKDF2: 
    valueFrom:
      secretKeyRef:
        name: default-auth-secret
        key: passwordPBKDF2
  
  QBT_Core__AutoDeleteAddedTorrentFile: 'Never'

  CATEGORIES : |
    {
      "books": {
          "save_path": ""
      },
      "manga": {
          "save_path": "/data/seed/manga/unlinked"
      },
      "programmes": {
          "save_path": ""
      },
      "prowlarr": {
          "save_path": ""
      },
      "radarr": {
          "save_path": "/data/seed/films/hardlinked"
      },
      "sonarr": {
          "save_path": "/data/seed/series/hardlinked"
      },
      "tmp": {
          "save_path": ""
      }
    }

# -- Configures service settings for the chart.
# @default -- See values.yaml
service:
  main:
    ports:
      http:
        port: 8080
  bittorrent:
    enabled: false
    type: ClusterIP
    ports:
      bittorrent:
        enabled: true
        port: 6881
        protocol: TCP
        targetPort: 6881

ingress:
  # -- Enable and configure ingress settings for the chart under this key.
  # @default -- See values.yaml
  main:
    enabled: true

    annotations:
      hajimari.io/enable: "true"
      hajimari.io/group: "Media"
      hajimari.io/icon: "cart-arrow-down"
      traefik.ingress.kubernetes.io/router.middlewares: "default-authentik-forward-auth@kubernetescrd"
      cert-manager.io/cluster-issuer: {{ .Values.clusterIssuer }}

    hosts:
      -  # -- Host address. Helm template can be passed.
        host: tor2.dartus.fr
        ## Configure the paths for the host
        paths:
          -  # -- Path.  Helm template can be passed.
            path: /
            # -- Ignored if not kubeVersion >= 1.14-0
            pathType: Prefix
    tls:
      - hosts:
        - tor2.dartus.fr
        secretName: tor2.dartus.fr-tls


# -- Configure persistence settings for the chart under this key.
# @default -- See values.yaml
persistence:
  test:
    enabled: yes
    type: configMap
    name: qbittorrent-config
    mountPath: /localConfig/categories.json
    subPath: categories.json
    readOnly: false

  media:
    enabled: false
    mountPath: /media

  downloads:
    enabled: true
    type : pvc
    existingClaim: pvc-dl
    size: 200Mi

metrics:
  # -- Enable and configure prometheus-qbittorrent-exporter sidecar and Prometheus podMonitor.
  # @default -- See values.yaml
  enabled: false
  serviceMonitor:
    interval: 15s
    scrapeTimeout: 5s
    labels: {}
  # -- Enable and configure Prometheus Rules for the chart under this key.
  # @default -- See values.yaml
  prometheusRule:
    enabled: false
    labels: {}
    # -- Configure additionial rules for the chart under this key.
    # @default -- See prometheusrules.yaml
    rules: []
      # - alert: qBittorrentDown
      #   annotations:
      #     description: qBittorrent service is down.
      #     summary: qBittorrent is down.
      #   expr: |
      #     qbittorrent_up == 0
      #   for: 5m
      #   labels:
      #     severity: critical
  exporter:
    image:
      # -- image repository
      repository: esanchezm/prometheus-qbittorrent-exporter
      # -- image tag
      tag: v1.2.0
      # -- image pull policy
      pullPolicy: IfNotPresent
    env:
      # -- qbittorrent username
      # update value after configuring qbittorrent
      user: "admin"
      # -- qbittorrent password
      # update value after configuring qbittorrent
      password: "adminadmin"
      # -- metrics port
      port: 9022
      # -- log level [DEBUG|INFO|WARNING|ERROR|CRITICAL]
      logLevel: INFO
{{- end }}