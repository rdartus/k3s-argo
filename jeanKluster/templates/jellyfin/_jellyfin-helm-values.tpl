{{- define "helmValues.jellyfin" }}

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: jellyfin
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "10"

spec:
  destination:
    namespace: default
    server: {{ .Values.dest_server }}
  project: default
  syncPolicy:
    automated: # automated sync by default retries failed attempts 5 times with following delays between attempts ( 5s, 10s, 20s, 40s, 80s ); retry controlled using `retry` field.
      prune: true # Specifies if resources should be pruned during auto-syncing ( false by default ).
      selfHeal: true
      allowEmpty: true
    syncOptions:
      - CreateNamespace=true
  source:
    chart: jellyfin
    targetRevision: "9.5.3"
    repoURL: https://geek-cookbook.github.io/charts/
    helm : 
      values: |

        #
        # IMPORTANT NOTE
        #
        # This chart inherits from our common library chart. You can check the default values/options here:
        # https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml
        #

        image:
          # -- image repository
          repository: lscr.io/linuxserver/jellyfin
          # -- image tag
          # @default -- chart.appVersion
          tag: latest
          # -- image pull policy
          pullPolicy: IfNotPresent

        # -- environment variables. See [image docs](https://jellyfin.org/docs/general/administration/configuration.html) for more details.
        # @default -- See below
        env:
          # -- Set the container timezone
          TZ: UTC
          DOTNET_HOSTBUILDER__RELOADCONFIGONCHANGE: false

        # -- Configures service settings for the chart.
        # @default -- See values.yaml
        service:
          main:
            ports:
              http:
                port: 8096


        ingress:
          # -- Enable and configure ingress settings for the chart under this key.
          # @default -- See values.yaml

          main:
            enabled: true
            annotations:
              hajimari.io/enable: "true"
              hajimari.io/group: "Media"
              hajimari.io/icon: "video-vintage"
              cert-manager.io/cluster-issuer: {{ .Values.clusterIssuer }}

            hosts:
              -  # -- Host address. Helm template can be passed.
                host: stream2.dartus.fr
                ## Configure the paths for the host
                paths:
                  -  # -- Path.  Helm template can be passed.
                    path: /
                    # -- Ignored if not kubeVersion >= 1.14-0
                    pathType: Prefix

            tls:
              - hosts:
                - stream2.dartus.fr
                secretName: stream2.dartus.fr-tls

        # -- Configure persistence settings for the chart under this key.
        # @default -- See values.yaml
        persistence:
          config:
            enabled: false

          # Cache does NOT contain temporary transcoding data.
          cache:
            enabled: false
            mountPath: /cache

          media:
            enabled: false
            mountPath: /media

        # -- Configure the Security Context for the Pod
        podSecurityContext: {}
        #   runAsUser: 568
        #   runAsGroup: 568
        #   fsGroup: 568
        #   # Hardware acceleration using an Intel iGPU w/ QuickSync
        #   # These IDs below should be matched to your `video` and `render` group on the host
        #   # To obtain those IDs run the following grep statement on the host:
        #   # $ cat /etc/group | grep "video\|render"
        #   # video:x:44:
        #   # render:x:109:
        #   supplementalGroups:
        #   - 44
        #   - 109

        # resources:
        #   requests:
        #     # Hardware acceleration using an Intel iGPU w/ QuickSync and
        #     # using intel-gpu-plugin (https://github.com/intel/intel-device-plugins-for-kubernetes)
        #     gpu.intel.com/i915: 1
        #     cpu: 200m
        #     memory: 256Mi
        #   limits:
        #     # Hardware acceleration using an Intel iGPU w/ QuickSync and
        #     # using intel-gpu-plugin (https://github.com/intel/intel-device-plugins-for-kubernetes)
        #     gpu.intel.com/i915: 1
        #     memory: 4096Mi
{{- end }}
