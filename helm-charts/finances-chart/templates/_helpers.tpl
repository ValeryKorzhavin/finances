{{/*
Expand the name of the chart.
*/}}
{{- define "finances-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "finances-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "finances-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "finances-chart.labels" -}}
helm.sh/chart: {{ include "finances-chart.chart" . }}
{{ include "finances-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "finances-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "finances-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "finances-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "finances-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "finances-chart.gateway.defaultName" -}}
{{- printf "gatway-$s" .Release.Name -}}
{{- end -}}

{{- define "finances-chart.gateway.deployment.name" -}}
{{- default (include "finances-chart.gateway.defaultName" .) .Values.gateway.deployment.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "finances-chart.gateway.service.name" -}}
{{- default (include "finances-chart.gateway.defaultName" .) .Values.gateway.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "finances-chart.registry.defaultName" -}}
{{- printf "registry-$s" .Release.Name -}}
{{- end -}}

{{- define "finances-chart.registry.deployment.name" -}}
{{- default (include "finances-chart.registry.defaultName" .) .Values.registry.deployment.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "finances-chart.registry.service.name" -}}
{{- default (include "finances-chart.registry.defaultName" .) .Values.registry.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*{{- define "finances-chart.propertiesHash" -}}*/}}
