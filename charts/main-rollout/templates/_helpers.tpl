{{/*
Expand the name of the chart.
*/}}
{{- define "main.name" -}}
{{- default .Chart.Name .Values.title | trunc 63 | trimSuffix "-" | replace " " "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}

{{- define "main.fullname" -}}
{{- if .Values.stage }}
{{- .Values.stage | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.title }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" | replace " " "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "main.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace " " "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "main.labels" -}}
helm.sh/chart: {{ include "main.chart" . }}
{{ include "main.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "main.selectorLabels" -}}
app.kubernetes.io/name: {{ include "main.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
env: {{ .Values.env }}
app: {{ .Values.app }}
{{- end }}

{{/*
Container port
*/}}

{{- define "main.port" -}}
{{- if .Values.rollout.port.enabled -}}
{{- .Values.rollout.port.containerport }}
{{- else }}
{{- "" }}
{{- end }}
{{- end }}

{{/*
Rollout connect service
*/}}
{{- define "rollout.svc" }}
canaryService: {{ include "main.fullname" $ }}-canary-svc
stableService: {{ include "main.fullname" $ }}-stable-svc
{{- end }}


{{/*
strategy steps
*/}}
{{- define "strategy.step" -}}
{{- if .Values.rollout.strategy }}
{{- .Values.rollout.strategy | toYaml }}
{{- else -}}
- setWeight: 20
- pause: { duration: 5m }
- setWeight: 30
- pause: { duration: 10m }
- setWeight: 70
- pause: { duration: 60m }
- pause: {}
{{- end }}
{{- end }}

{{/*
Create Service 
*/}}
{{- define "create.service" -}}
{{- if .Values.service.rootService.enabled }}
name:
    - canary
    - stable
    - root
{{- else }}
name:
    - canary
    - stable
{{- end }}
{{- end }}

{{/*
Ingress annotation
*/}}

{{- define "ingress.annotations" -}}
kubernetes.io/ingress.class: alb
alb.ingress.kubernetes.io/scheme: {{ .Values.ingress.scheme }}
alb.ingress.kubernetes.io/target-type: {{ .Values.ingress.target_type }}
{{- if .Values.ingress.subnets }}
alb.ingress.kubernetes.io/subnets: {{ .Values.ingress.subnets }}
{{- if .Values.ingress.security_groups }}
alb.ingress.kubernetes.io/security-groups: {{ .Values.ingress.security_groups }}
{{- end }}
{{- end }}
{{- end }}