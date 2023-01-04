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
