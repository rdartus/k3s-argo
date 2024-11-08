{{- define "helmValues.pgdump" }}

dest_server : {{ .Values.dest_server }}  
default_folder_app : {{ .Values.default_folder_app }}  

db :
    appName: {{ .Values.db.appName }} 
    namespace: {{ .Values.db.namespace }} 
    user: {{ .Values.db.arr_user }} 
    userPass: {{ .Values.db.arr_userPass }} 

arr:
    user : {{ .Values.arr.user }} 
    userPass : {{ .Values.arr.userPass }} 

{{- end }}