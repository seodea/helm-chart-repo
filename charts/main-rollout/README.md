# Internal Test Main Helm Chart

Internall test용인 Main Rollout Helm Chart입니다.  
Argocd Rollouts을 이용하여 배포를 원할경우, Subchart형식을 사용을 하여 실제 사용하는 value 값들은 [project](./project)의 각 서비스에서 `value-*` 파일에 의해 받아옵니다. 
이렇게 사용을 했을 때의 장점은 : 
- main helm chart는 수정이 필요하지않음
- 각 서비스 or 여러 환경에서 사용을 하더라도 main helm chart만 수정을 하면 모두 반영이 이루어짐

## 폴더 구조
- Chart.yaml : chart helm package를 위해서 apiVersion은 v2이며, name, version에 대한 정보를 가지고 있습니다.  
type은 Application과 Library 방식이 있지만, Library은 사용하는데 복잡합니다.
- templates/ : 해당 폴더 아래에 helm chart가 있으며 현재 Object는 deployment, service, ingress만 있습니다.  
_helpers.tpl은 필요 시 변수값을 가공을 해야될때, 사용을 합니다.
- values.yaml : 변수값 설정이 되어있으면, overwrite 되며 없을 경우 해당 values에 있는 내용을 사용하게 됩니다.

```
.
├── Chart.yaml
├── README.md
├── charts/
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── rollouts.yaml
│   ├── eks-ingress.yml
│   └── service.yaml
└── values.yaml
```