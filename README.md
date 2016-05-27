# prometheus
Playground for Prometheus open-source monitoring solution.

##General info
https://prometheus.io/


##Installation
###From source
https://github.com/prometheus/prometheus/blob/0.19.1/README.md#building-from-source

###From Docker
Installing Prometheus with Docker: https://prometheus.io/docs/introduction/install/
* `docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus`
* `docker run -p 9090:9090 -v /prometheus-data prom/prometheus -config.file=/prometheus-data/prometheus.yml`
* `docker run -p 9090:9090 prom/prometheus`

Run on [http://localhost:9090/graph](http://localhost:9090/graph)

###Example targets
https://prometheus.io/docs/introduction/getting_started/#starting-up-some-sample-targets


##Grafana
###Docker
`docker pull grafana/grafana:3.0.1`

###Installation using brew
`brew install grafana/grafana/grafana`

To have launchd start grafana/grafana/grafana at login:
* `ln -sfv /usr/local/opt/grafana/*.plist ~/Library/LaunchAgents`

Then to load grafana/grafana/grafana now:
* `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.grafana.plist`
