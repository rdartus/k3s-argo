{{- define "helmValues.automate-wx" }}

#
# IMPORTANT NOTE
#
# This chart inherits from the bjw-s library chart. You can check the default values/options here:
# https://github.com/bjw-s/helm-charts/tree/main/charts/library/common
#

controllers:
  main:
    # -- enable the controller.
    enabled: true

    # -- Set the controller type.
    # Valid options are deployment, daemonset, statefulset, cronjob or job
    type: cronjob
    
    annotations: {}
    # -- Set labels on the deployment/statefulset/daemonset/cronjob/job
    labels: {}
    # -- Number of desired pods. When using a HorizontalPodAutoscaler, set this to `null`.
    replicas: 1
    # -- Set the controller upgrade strategy
    # For Deployments, valid values are Recreate (default) and RollingUpdate.
    # For StatefulSets, valid values are OnDelete and RollingUpdate (default).
    # DaemonSets/CronJobs/Jobs ignore this.
    strategy:

    rollingUpdate:
      # -- Set deployment RollingUpdate max unavailable
      unavailable:
      # -- Set deployment RollingUpdate max surge
      surge:
      # -- Set statefulset RollingUpdate partition
      partition:
    # -- ReplicaSet revision history limit
    revisionHistoryLimit: 3

    # -- Set the controller service account name
    # This is entirely optional, if empty or `null` the controller will use the default service account
    serviceAccount:
      # -- Only use one of `name` or `identifier`. In case both are specified it will prioritize `identifier`.
      # -- Reference a service account identifier from this values.yaml
      identifier:
      # -- Explicitly set the service account name
      name:
    # -- CronJob configuration. Required only when using `controller.type: cronjob`.
    # @default -- See below
    cronjob:
      # -- Suspends the CronJob
      # [[ref]](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#schedule-suspension)
      # @default -- false
      suspend:
      # -- Specifies how to treat concurrent executions of a job that is created by this cron job
      # valid values are Allow, Forbid or Replace
      concurrencyPolicy: Replace
      # -- Sets the CronJob timezone (only works in Kubernetes >= 1.27)
      timeZone:
      # -- Sets the CronJob time when to execute your jobs
      schedule: "0 5 * * *"
      # -- The deadline in seconds for starting the job if it misses its scheduled time for any reason
      startingDeadlineSeconds: 30
      # -- The number of succesful Jobs to keep
      successfulJobsHistory: 1
      # -- The number of failed Jobs to keep
      failedJobsHistory: 1
      # -- If this field is set, ttlSecondsAfterFinished after the Job finishes, it is eligible to
      # be automatically deleted.
      ttlSecondsAfterFinished:
      # -- Limits the number of times a failed job will be retried
      backoffLimit: 6
      # -- Specify the number of parallel jobs
      parallelism:
    # -- Whether to apply defaultContainerOptions to initContainers
    applyDefaultContainerOptionsToInitContainers: true
    # -- Set the strategy for the default container options. Defaults to
    #    overwrite: If container-level options are set, use those instead of the defaults.
    #    merge: If container-level options are set, merge them with the defaults
    # @default -- overwrite
    defaultContainerOptionsStrategy: overwrite
    # -- Set default options for all (init)Containers here
    # Each of these options can be overridden on a container level
    defaultContainerOptions:
      image:
        # -- Override the image repository for the containers
        repository: ghcr.io/rdartus/automate-wx
        # -- Override the image tag for the containers
        tag: latest
        # -- Override the image pull policy for the containers
        pullPolicy: IfNotPresent
      # -- Override the command(s) for the containers
      command:
      # -- Override the args for the containers
      args:
      # -- Environment variables.
      env:
      # -- Secrets and/or ConfigMaps that will be loaded as environment variables.
      envFrom: {}
      # -- Set the resource requests / limits for the container.
      resources:
      # -- Configure the Security Context for the container
      securityContext: {}

    containers:
      main:
        # -- Override the container name
        nameOverride:

        # -- Specify if this container depends on any other containers
        # This is used to determine the order in which the containers are rendered.
        dependsOn: []

        image:
          # -- image repository
          repository:
          # -- image tag
          tag:
          # -- image pull policy
          pullPolicy:

        # -- Override the command(s) for the container
        command: []
        # -- Override the args for the container
        args: []
        # -- Override the working directory for the container
        workingDir:

        # -- Environment variables. Template enabled.
        # Syntax options:
        # A) TZ: UTC
        # B) PASSWD: '{{ .Release.Name }}'
        # B) TZ:
        #      value: UTC
        #      dependsOn: otherVar
        # D) PASSWD:
        #      configMapKeyRef:
        #        name: config-map-name
        #        key: key-name
        # E) PASSWD:
        #      dependsOn:
        #        - otherVar1
        #        - otherVar2
        #      valueFrom:
        #        secretKeyRef:
        #          name: secret-name
        #          key: key-name
        #      ...
        # F) - name: TZ
        #      value: UTC
        # G) - name: TZ
        #      value: '{{ .Release.Name }}'
        env:
          USER_WX:
            valueFrom:
              secretKeyRef:
                name: wx-secret
                key: username
          PASSWORD_WX:
            valueFrom:
              secretKeyRef:
                name: wx-secret
                key: password
        # -- Secrets and/or ConfigMaps that will be loaded as environment variables.
        # Syntax options:
        # A) Pass an app-template configMap identifier:
        #    - config: config
        # B) Pass any configMap name that is not also an identifier (Template enabled):
        #    - config: random-configmap-name
        # C) Pass an app-template configMap identifier, explicit syntax:
        #    - configMapRef:
        #        identifier: config
        # D) Pass any configMap name, explicit syntax (Template enabled):
        #    - configMapRef:
        #        name: "{{ .Release.Name }}-config"
        # E) Pass an app-template secret identifier:
        #    - secret: secret
        # F) Pass any secret name that is not also an identifier (Template enabled):
        #    - secret: random-secret-name
        # G) Pass an app-template secret identifier, explicit syntax:
        #    - secretRef:
        #        identifier: secret
        # H) Pass any secret name, explicit syntax (Template enabled):
        #    - secretRef:
        #        name: "{{ .Release.Name }}-secret"
        envFrom: []

        # -- Probe configuration
        # -- [[ref]](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
        probes:
          # -- Liveness probe configuration
          # @default -- See below
          liveness:
            # -- Enable the liveness probe
            enabled: false
            # -- Set this to `true` if you wish to specify your own livenessProbe
            custom: false
            # -- sets the probe type when not using a custom probe
            # @default -- "TCP"
            type: TCP
            # -- The spec field contains the values for the default livenessProbe.
            # If you selected `custom: true`, this field holds the definition of the livenessProbe.
            # @default -- See below
            spec:
              initialDelaySeconds: 0
              periodSeconds: 10
              timeoutSeconds: 1
              failureThreshold: 3

          # -- Readiness probe configuration
          readiness:
            # -- Enable the readiness probe
            enabled: false
            # -- Set this to `true` if you wish to specify your own readinessProbe
            custom: false
            # -- sets the probe type when not using a custom probe
            # @default -- "TCP"
            type: TCP
            # -- The spec field contains the values for the default readinessProbe.
            # If you selected `custom: true`, this field holds the definition of the readinessProbe.
            # @default -- See below
            spec:
              initialDelaySeconds: 0
              periodSeconds: 10
              timeoutSeconds: 1
              failureThreshold: 3

          # -- Startup probe configuration
          startup:
            # -- Enable the startup probe
            enabled: false
            # -- Set this to `true` if you wish to specify your own startupProbe
            custom: false
            # -- sets the probe type when not using a custom probe
            # @default -- "TCP"
            type: TCP
            # -- The spec field contains the values for the default startupProbe.
            # If you selected `custom: true`, this field holds the definition of the startupProbe.
            # @default -- See below
            spec:
              initialDelaySeconds: 0
              timeoutSeconds: 1
              ## This means it has a maximum of 5*30=150 seconds to start up before it fails
              periodSeconds: 5
              failureThreshold: 30

service:
  main:
    # -- Enables or disables the service
    enabled: true

    # -- Override the name suffix that is used for this service
    nameOverride: ""

    # -- Configure which controller this service should target
    controller: main

    # -- Make this the primary service for this controller (used in probes, notes, etc...).
    # If there is more than 1 service targeting the controller, make sure that only 1 service is
    # marked as primary.
    primary: true

    # -- Set the service type
    type: ClusterIP



{{- end }}
