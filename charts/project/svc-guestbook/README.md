## guestbook 용도

Internal Test를 위한 Service입니다.
Main Helm Chart를 이용하여 간단하게 images, replica, ingress, label 정도만 수정을 합니다.

### dependencies 작성

echoserver의 Chart.yaml 내의 dependencies.repository는 `URL`를 사용을 하고 있습니다.
git clone 시 Local에서 테스트에만 가능 하며, ArgoCD에서 사용 시 Private URL일 경우 `권한 문제` 사용이 불가능합니다.

에러 내용
> rpc error: code = Unknown desc = Manifest generation error (cached): `helm repo add https:--gitlab.mzcloud.xyz-api-v4-projects-328-packages-helm-sdh https://gitlab.mzcloud.xyz/api/v4/projects/328/packages/helm/sdh` failed exit status 1: Error: looks like "https://gitlab.mzcloud.xyz/api/v4/projects/328/packages/helm/sdh" is not a valid chart repository or cannot be reached: failed to fetch https://gitlab.mzcloud.xyz/api/v4/projects/328/packages/helm/sdh/index.yaml : 401 Unauthorized

단, 사전에 Local에서 테스트 시 해당 URL이 local repo에 add가 되어있어야 합니다.

- local 테스트 방법
  ```
  helm repo add '{repo 이름}' https://gitlab.mzcloud.xyz/api/v4/projects/328/packages/helm/sdh --username '{사용자 이름}' --password '{암호}'
  cd {svc-echoserver path} 
  helm dependency build
  helm template test . -f values-dev.yaml
  ```

> Chart.yaml 에서 dependencies 작성 시 ArgoCD는 아래 내용을 가지고 git에서 배포를 할 경우에도 
> name, version, repository 경로를 확인을 하기 때문에 해당 내용이 main helm chart와 다를 경우 Application 생성이 되지 않음

예시 
```
dependencies:
  - name: subchart-test # Parent chart name 이름 
    version: 0.1.0 # Parent chart version 기입 (helm package version 변경 시 원하는 버전으로 변경 필요)
    repository: "https://gitlab.mzcloud.xyz/api/v4/projects/328/packages/helm/sdh" # Private URL일 경우 되지않음 ArgoCD에서 테스트 시 Public URL로 변경 필수
```

## Argo CD 배포 방식
해당 폴더에 있는 `dev-echoserver-project.yaml` 파일을 이용하여 Argo CD Console or Argo CD cli로 배포를 합니다
단, 해당 파일은 dev 환경에 대한 배포로 아래와 같이 dev values 파일을 조회를 합니다.
```
{생략}
source:
  path: charts/project/svc-guestbook
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