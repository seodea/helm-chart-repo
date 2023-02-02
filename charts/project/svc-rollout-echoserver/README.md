## rollout-echoserver 용도

Internal Test를 위한 Service입니다. 해당 서비스는 Argo CD의 Rollout를 사용을 하기 위해 기존 Chart는 다른 Helm Package를 사용을 합니다.
Main Helm Chart를 이용하여 간단하게 images, replica, ingress, label 정도만 수정을 합니다.

### dependencies 작성

rollout-echoserver의 Chart.yaml 내의 dependencies.repository는 `file://` 을 사용을 하고 있습니다.
git clone 시 Local에서 테스트 or Argo CD 내에서 모두 사용 가능합니다.

- local 테스트 방법
  ```
  cd {svc-echoserver path}
  helm dependency build
  helm template test . -f values-dev.yaml
  ```

> Chart.yaml 에서 dependencies 작성 시 ArgoCD는 아래 내용을 가지고 git에서 배포를 할 경우에도 
> name, version, repository 경로를 확인을 하기 때문에 해당 내용이 main helm chart와 다를 경우 Application 생성이 되지 않음

예시 
```
dependencies:
  - name: subchart-test # parent chart name
    version: 0.1.0 # parent chart version (helm package version 변경 시 원하는 버전으로 변경 필요)
    repository: "file://../main-rollout/" # parent chart path
```

## Argo CD 배포 방식
해당 폴더에 있는 `dev-echoserver-project.yaml` 파일을 이용하여 Argo CD Console or Argo CD cli로 배포를 합니다
단, 해당 파일은 dev 환경에 대한 배포로 아래와 같이 dev values 파일을 조회를 합니다.
```
{생략}
source:
  path: charts/project/svc-rollout-echoserver
  repoURL: 'https://gitlab.mzcloud.xyz/ctc/truefriend/korea-investment/internal.git'
  targetRevision: HEAD
  helm:
    valueFiles:
      - values-dev.yaml
```

다른 환경을 배포를 하고 싶다면 valueFiles를 다른걸로 선택을 합니다.

예시
```
{생략}
helm:
  valueFiles:
    - values-test.yaml or values-prod.yaml
```

## 테스트 방법
Image를 변경을 하여 배포하여 테스트를 합니다.
