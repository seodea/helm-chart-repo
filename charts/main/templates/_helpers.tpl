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
Define service name
*/}}
{{- define "service.fullname" -}}
{{- if .Values.service.enabled }}
{{- printf "%s-%s" "svc" .Values.service.name | trunc 63 }}
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
{{- if .Values.deployment.port.enabled -}}
{{- .Values.deployment.port.containerport }}
{{- else }}
{{- "" }}
{{- end }}
{{- end }}

{{/*
Ingress annotation
*/}}

{{- define "ingress.annotations" -}}
alb.ingress.kubernetes.io/scheme: {{ .Values.ingress.scheme }}
alb.ingress.kubernetes.io/target-type: {{ .Values.ingress.target_type }}
{{- if .Values.ingress.subnets }}
alb.ingress.kubernetes.io/subnets: {{ .Values.ingress.subnets }}
{{- if .Values.ingress.security_groups }}
alb.ingress.kubernetes.io/security-groups: {{ .Values.ingress.security_groups }}
{{- end }}
{{- end }}
{{- end }}