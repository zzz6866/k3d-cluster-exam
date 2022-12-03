## Helm 설치
- helm search repo prometheus-community # repository에서 prometheus-community 검색
- helm install prometheus stable/prometheus --namespace prometheus # 설치
- helm repo add prometheus-community https://prometheus-community.github.io/helm-charts # repository 추가
- helm repo update # repository 업데이트
- helm install prometheus prometheus-community/kube-prometheus-stack --namespace prometheus # kube-prometheus-stack 설치 
- kubectl --namespace prometheus get pods -l "release=prometheus" # 설치 확인 
- prometheus-ingress.yaml 파일 실행(ingress 규칙 생성)
