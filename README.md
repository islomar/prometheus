# prometheus
Playground for Prometheus open-source monitoring solution.

##General info
https://prometheus.io/


##Installation
Installing Prometheus with Docker: https://prometheus.io/docs/introduction/install/
`docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus`
`docker run -p 9090:9090 -v /prometheus-data prom/prometheus -config.file=/prometheus-data/prometheus.yml`
`docker run -p 9090:9090 prom/prometheus`

Run on `http://localhost:9090/graph`


docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml:rw prom/prometheus
docker run -p 9090:9090 -v $(pwd)/prometheus-data prom/prometheus -config.file=$(pwd)/prometheus-data/prometheus.yml




##Grafana
`brew install grafana/grafana/grafana`
To have launchd start grafana/grafana/grafana at login:
  `ln -sfv /usr/local/opt/grafana/*.plist ~/Library/LaunchAgents`
Then to load grafana/grafana/grafana now:
  `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.grafana.plist`