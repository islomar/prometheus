# prometheus
Playground for Prometheus open-source monitoring solution.

##Event
* http://blog.shuttlecloud.com/prometheus-workshop-saturday-may-28-930-am/
* https://www.eventbrite.com/e/prometheus-workshop-tickets-23246289277
* Hashtag: #WorkshopsWeLove
* Brian Brazil
  * https://www.linkedin.com/in/brianbrazil
  * https://twitter.com/RobustPerceiver
* http://goog.gl/b080L

##Interesting links
* http://play.grafana.org/dashboard/db/prometheus-demo-dashboard
* http://demo.robustperception.io:9090/consoles/life.html
* https://5pi.de/2015/01/26/monitor-docker-containers-with-prometheus/
* Docker container exporter: https://github.com/docker-infra/container_exporter

##URLs
* http://demo.robustperception.io:9090/consoles/index.html
* http://localhost:9090/consoles/prometheus.html
* http://localhost:9090/rules
* http://demo.robustperception.io:9100

###Talk
* Exercises: https://docs.google.com/document/d/1uJ4AfmAs4S7pX8jgR1m6RQAaw49d-b4yLTsgOnt_VHQ/edit
* Slides:  http://www.slideshare.net/brianbrazil/prometheus-overview?ref=https://cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fwww.slideshare.net%2Fslideshow%2Fembed_code%2Fkey%2Fq8yi1MRgLXj7cG&url=https%3A%2F%2Fwww.slideshare.net%2Fbrianbrazil%2Fprometheus-overview&image=https%3A%2F%2Fcdn.slidesharecdn.com%2Fss_thumbnails%2Fprometheusoverview-public-151001193747-lva1-app6892-thumbnail-4.jpg%3Fcb%3D1443766584&key=03fb819bf74246bf972444a07b738ad0&type=text%2Fhtml&schema=slideshare
* Reload configuration: http://www.robustperception.io/reloading-prometheus-configuration/
  * curl -X POST http://localhost:9090/-/reload
  * kill -HUP <process_id>
* Time series: something tracked over time.
  * Time series: metric name and labels (key-value)
* Inclusive monitoring: don't monitor just at the edges... client libraries, server libraries, business logic.
* Prom is about **pulling** in lots of information about lots of instances.
* Written in Go
* Prom status:  http://localhost:9090/status
* Targets: http://localhost:9090/targets
* Data stored under prometheus/data
* Started a node exported and created a new job on yml pointing there.
  * Instead of starting a node_exporter, you can point to demo.robustperception.io:9100
* http://localhost:9090/consoles/node.html
* Basic types for a time serie (https://prometheus.io/docs/concepts/metric_types/):
  * Gauges: gauges are a snapshot of state. Usually, you want to work with gauges, and you convert Counters to Gauges
    * Gauges can go both up and down
    * You care about the absolute value of a Gauge.
    * Examples of Gauges:
      * Temperature
      * Items in queue
      * Start time of a process
      * Memory used
      * Queries in the past five minutes
      * Latency
  * Counters: 
    * It starts at 0, and is incremented. Prom samples it regularly. Resilient to scrape failures, can have multiple scrapers.
    * Counters can not be decremented.
    * By convention, counters end in "_total"
    * Counters are good to track events: e.g. for each request, each failure...
    * If you matter the absolute value, use a Gauge.
* There are 2 compound types:
  * Summary:
    * Compute quantiles on the client, expose as gauge.
    * Tend to be slow and expensive to calculate on client
    * Can't be aggregated
  * Histogram
    * Put each event size into bucket, expose as counters
    * It can be aggregated and it's cheap on the client.
    * Cons: have to pre-choose buckets
* Labels:
  * Each potential combination of labels is a potential time series.
* All Prom values are 64bit floating point. NaN, +Inf, -Inf are possible
* Conventions:
  * Avoid the le and quantile labels
  * Avoid the _total, _sum,  _count suffixes outside their types
  * Put the unit name in the metric
* Samples are float64, timestamps have millisecond resolution.
* Labels are key-value pairs, UTF-8.
* PromQL:
  * Query language of Prom.
  * Strongly typed, four types:
    * Scalars
    * Vectors
    * Range vectors
    * Strings
  * Functions: there are 37 (math, counters, etc)
    * rate, increase, irate and resets only on counters. All other functions work on gauges.
    * Functions that take a range vector always return a vector.
    * Math: abs, ceil, exp, floor, round, sqrt, etc.
    * `time()`: used to substract times in gauges from
    * `changes()`: it takes a range vector and counts the number of times each time series changed.
      * e.g. `changes(node_cpu{mode=~".*"} [5m])`
    * `deriv()`: to detect if a gauge is getting worse.
    * `predict_linear()`, only for gauges, it predicts a value in the future
    * Use increase() for display, use rate() in rules
    * `irate()`doesn't do well for alerting or longer time frames.
    * EXAMPLES:
      * Examples: https://prometheus.io/docs/querying/examples/
      * `count without(device) (node_disk_bytes_read{job="node"})`
      * Example: `rate(http_requests_total{code='200'}[5m])`
      * `sum(rate(http_requests_total[5m])) by (job)`
  * Aggregators
    * `sum without (cpu)(rate(node_cpu{mode="idle"}[5m])) / ignoring(mode) sum without(cpu, mode)(rate(node_cpu[5m]))`
    * `sum without (cpu)(rate(node_cpu{mode="idle"}[5m])) / ignoring(mode) group_left sum without(cpu, mode)(rate(node_cpu[5m]))`
  * Machine role labels
    * Bad practice to apply a label to entire target that can change during its lifetime
    * Use machine roles: http://www.robustperception.io/how-to-have-labels-for-machine-roles/
  * Examples:
    * What's the percentage of disk space used on each filesystem?
      * `(sum without(mountpoint,ftype,device)(node_filesystem_avail))/sum without(mountpoint,fstype,device)(node_filesystem_size)*100`
    * What's the overall percentage of disk space free per machine?
      * 
    * How many storage operations is Prometheus doing per second?
      * `sum without (type)(rate(promethus_local_storage_chunk_ops_total[5m]))`
    * How many machines have more than 2 cores?
      * count(node_cpu{mode="idle",mode="cpu2"}) or vector(0)
      * sum without(mode)(node_cpu)
      * count without(cpu)(sum without(mode)(node_cpu))
      * sum(count without(cpu)(sum without(mode)(node_cpu)) > bool 2)
  * There are 3 ways to get to PromQL
    * HTTP API
  * Recording rules
    * https://prometheus.io/docs/querying/rules/
    * http://localhost:9090/rules
    * Recording rules allow you to precompute frequently needed or computationally expensive expressions and save their result as a new set of time series. Querying the precomputed result will then often be much faster than executing the original expression every time it is needed. This is especially useful for dashboards, which need to query the same expression repeatedly every time they refresh.
    * When to use rules? 
      * To pre-compute expensive queries (touching >100-1000 time series)
      * When you need a range vector input, but only have a vector output
      * To produce aggregates that'll be picked up by federation
  * File service discovery:
    * http://www.robustperception.io/using-json-file-service-discovery-with-prometheus/
    * https://prometheus.io/blog/2015/06/01/advanced-service-discovery/

####Instrumentation
* https://prometheus.io/docs/instrumenting/clientlibs/
* Python client: https://github.com/prometheus/client_python


##General info
* https://prometheus.io/


##Installation

###Prometheus
####From source
https://github.com/prometheus/prometheus/blob/0.19.1/README.md#building-from-source

####From Docker
Installing Prometheus with Docker: https://prometheus.io/docs/introduction/install/
`docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus`
`docker run -p 9090:9090 -v /prometheus-data prom/prometheus -config.file=/prometheus-data/prometheus.yml`
`docker run -p 9090:9090 prom/prometheus`

Run on `http://localhost:9090/graph`

docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml:rw prom/prometheus
docker run -p 9090:9090 -v $(pwd)/prometheus-data prom/prometheus -config.file=$(pwd)/prometheus-data/prometheus.yml

###Example targets
https://prometheus.io/docs/introduction/getting_started/#starting-up-some-sample-targets


###Blackbox
https://github.com/prometheus/blackbox_exporter/blob/0.1.0/README.md

###node_exporter

###Grafana
###Docker
`docker pull grafana/grafana:3.0.1`

###Installation using brew
`brew install grafana/grafana/grafana`
To have launchd start grafana/grafana/grafana at login:
  `ln -sfv /usr/local/opt/grafana/*.plist ~/Library/LaunchAgents`
Then to load grafana/grafana/grafana now:
  `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.grafana.plist`