# Project 폴더 용도

Project 폴더는 3개의 예시 서비스를 제공을 하고 있습니다.
3개의 서비스는 모두 1개의 helm chart를 사용하는 subchart 방식으로 yaml 파일을 구성 및 배포를 하고 있습니다.

단, 차이점으로는 각각의 서비스가 사용하는 Chart.yaml의 dependency 방식이 상이합니다.  
dependency는 총 3가지의 방식을 제공을 하고 있으며 이것을 모두 사용하고 있습니다.

- file://
- @, alias
- URL

Local 및 Argo CD에서 배포 시 모두 사용이 가능합니다.  
자세한 사용 방식은 각 폴더에 README를 참고 하시면 됩니다.

# Subchart 사용방법

Subchart를 사용하려면, Chart.yaml 파일과 values.yaml 파일을 작성하면 됩니다.

- Chart.yaml 작성 가이드
dependencies를 추가를 하여, 어떤 **Main Helm chart**를 사용을 하는지 정의를 해야합니다.  

name과 versino은 **Main Helm chart**에서 사용하는 name과 version으로 기입을 합니다.  
> version이 올라간다면, Chart.yaml 파일의 `dependencies.versiono`도 변경을 해야 합니다.
```
dependencies:
  - name: subchart-test # parent chart name
    version: 0.1.0 # parent chart version
    repository: "@mzc-gitlab-helm" # parent chart path
```

- values.yaml 파일 
원하는 변수값을 등록을 하여 사용을 하면 됩니다. 모든 변수값을 기입을 하여도 되지만, 기본 변수값(Main Helm Chart 폴더에 있는 value.yaml 파일 참고)을 사용을 해도 되면 기입을 하지 않아도 됩니다.  

단, values.yaml 파일 작성 시 dependencies에서 사용한 name을 작성 후 변수값을 작성을 해야합니다.

예시
```
subchart-test: # Chart.yaml에 있는 name으로 작서 후 변수값을 들여쓰기
  title: "c project nginx service"
  app: c
  env: dev

  deployment:
    replicas: 0
    image:
{생략...}
```