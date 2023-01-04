# ArgoCD 사용

## dependencies 작성

Chart.yaml 에서 dependencies 작성 시 ArgoCD는 아래 내용을 가지고 git에서 배포를 할 경우에도 
name, version, repository 경로를 확인을 하기 때문에 해당 내용이 main helm chart와 다를 경우 Application 생성이 되지 않음

dependencies:
  - name: subchart-test # parent chart name
    version: 0.1.0 # parent chart version
    repository: "file://../main/" # parent chart path

