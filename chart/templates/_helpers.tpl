{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "idex.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "idex.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "idex.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "idex.labels" -}}
helm.sh/chart: {{ include "idex.chart" . }}
{{ include "idex.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "idex.selectorLabels" -}}
app.kubernetes.io/name: {{ include "idex.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "idex.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "idex.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the image name
*/}}
{{- define "idex.image" -}}
{{- $runtimes := list "idex" "nodejs" "go" "php" "dart" "cpp" "java" "rust" -}}
{{if has .Values.runtime $runtimes }}
   {{- if eq .Values.runtime "nodejs" -}}
   {{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
   {{- else -}}
   {{- printf "%s-%s:%s" .Values.image.repository .Values.runtime .Values.image.tag -}}
   {{- end -}}
{{- else -}}
    {{- fail (printf "%s is not a valid runtime. Valid values are: %s" .Values.runtime $runtimes) -}}
{{- end -}}
{{- end -}}
