{{/*
Ensure at least one disk is given
*/}}
{{- define "biockubeinstall.manualDiskBlock" -}}
{{- if .Values.persistence.gcpPdName -}}
gcePersistentDisk:
  pdName: {{ .Values.persistence.gcpPdName }}
  fsType: ext4
{{- else -}}
{{- if .Values.persistence.azurePdHandle -}}
csi:
  driver: disk.csi.azure.com
  readOnly: false
  volumeHandle: {{ .Values.persistence.azurePdHandle }}
  volumeAttributes:
    fsType: ext4
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Extract the filename portion from a file path
*/}}
{{- define "biockubeinstall.getFilenameFromPath" -}}
{{- printf "%s" (. | splitList "/" | last) -}}
{{- end -}}

{{/*
Make string DNS-compliant by turning to lowercase then removing all noncompliant characters
*/}}
{{- define "biockubeinstall.makeDnsCompliant" -}}
{{- (printf "%s" (regexReplaceAll "[^a-z0-9-]" (. | lower) "")) | trunc 63 | trimSuffix "-"  }}
{{- end -}}

{{/*
Get unique name for extra files
*/}}
{{- define "biockubeinstall.getExtraFilesUniqueName" -}}
{{- (printf "%s" (include "biockubeinstall.makeDnsCompliant" (printf "extra-%s-%s" (include "biockubeinstall.getFilenameFromPath" .) (. | sha256sum))))  }}
{{- end -}}
