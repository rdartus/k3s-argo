{{- define "helmValues.tailscaleop" }}
---
controllers:
  tailscale:
    replicas: 1
    strategy: RollingUpdate
    annotations:
    containers:
      app:
        image:
          repository: ghcr.io/tailscale/tailscale
          tag: v1.78.3@sha256:9d4c17a8451e2d1282c22aee1f08d28dc106979c39c7b5a35ec6313d4682a43e
        env:
          TZ: Europe/Paris
          NO_AUTOUPDATE: true
          PORT: 5160 
          TS_EXTRA_ARGS: --advertise-exit-node  --advertise-tags=tag:k8s
          TS_HOSTNAME: exit
          TS_ROUTES: 192.168.20.0/22
          TS_AUTHKEY: 297f20acbf4e9aa9220f64bf9f4dc6e8819c0da10b6df8c5
          TS_STATE_DIR: /tmp
          TS_TAILSCALED_EXTRA_ARGS: --debug=0.0.0.0:9001
          TS_USERSPACE: true
        probes:
          liveness:
            enabled: true
            custom: true
            spec:
              httpGet:
                path: /debug/pprof/
                port: 9001
              initialDelaySeconds: 15
              periodSeconds: 20
              timeoutSeconds: 1
              failureThreshold: 3
          readiness: 
        resources:
          requests:
            cpu: 10m
          limits:
            memory: 256Mi
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          capabilities:
            drop:
              - ALL
defaultPodOptions:
  dnsPolicy: ClusterFirstWithHostNet
  hostNetwork: true
  securityContext:
    runAsNonRoot: true
    runAsUser: 568
    runAsGroup: 568
persistence:
  cache:
    type: emptyDir
    globalMounts:
      - path: /.cache
  tmp:
    type: emptyDir
    globalMounts:
      - path: *path
  run:
    type: emptyDir
    globalMounts:
      - path: /var/run
service:
  app:
    controller: tailscale
    nameOverride: tailscale
    ports:
      http:
        port: 9001
  tailnet:
    controller: tailscale
    type: LoadBalancer
    externalIPs: [192.168.1.5]
    externalTrafficPolicy: Local
    ipFamilyPolicy: PreferDualStack
    ipFamilies: [IPv4]
    ports:
      tailnet:
        port: 5160
        protocol: UDP
serviceMonitor:
  app:
    serviceName: tailscale
    endpoints:
      - port: http
        scheme: http
        path: /debug/metrics
        interval: 1m
        scrapeTimeout: 10s
{{- end }}