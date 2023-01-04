# internal test



## 폴더 구조

Subchart 구조를 사용 하기 위한 구조입니다.
main : helm chart 폴더
project : service 폴더 (현재 3가지의 서비스가 있음 echoserver, guestbook, nginx) 모두 main helm package를 dependency로 사용

> 단, 현재 Argo CD에서 배포를 하므로 Chart.yaml의 dependency가 path와 alias 로 설정이 되어 있습니다.
> 테스트 시 각 서비스의 Chart.yaml에서 원하는 값으로 변경 후 사용해야 합니다.

```
.
├── .gitlab-ci.yml
├── README.md
└── charts
    ├── main
    │   ├── Chart.yaml
    │   ├── charts
    │   ├── templates
    │   │   ├── NOTES.txt
    │   │   ├── _helpers.tpl
    │   │   ├── deployment.yaml
    │   │   ├── eks-ingress.yml
    │   │   └── service.yaml
    │   └── values.yaml
    └── project
        ├── svc-echoserver
        │   ├── Chart.yaml
        │   ├── README.md
        │   ├── charts
        │   ├── dev-echoserver-project.yaml
        │   ├── values-dev.yaml
        │   ├── values-prod.yaml
        │   └── values-test.yaml
        ├── svc-guestbook
        │   ├── Chart.yaml
        │   ├── charts
        │   ├── values-dev.yaml
        │   ├── values-prod.yaml
        │   └── values-test.yaml
        └── svc-nginx
            ├── Chart.yaml
            ├── README.md
            ├── charts
            ├── project-nginx-application.yaml
            ├── values-dev.yaml
            ├── values-prod.yaml
            └── values-test.yaml
```

## .gitlab-ci 용도
Root path에 .gitlab-ci.yml이 있으며, 해당 CI Pipeline은 main helm chart를 package하여 Gitlab의 Package Registry로 업로드 하기 위함입니다.
현재는 동작이 되지않게 주석처리가 되어있으므로, 사용 시 주석 `.` 해체 후 사용하시면 됩니다.