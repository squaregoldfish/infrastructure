# Prometheus monitoring stack

This role will install a docker-based Prometheus stack.

The stack has five separate parts, running in five different containers:
1. prometheus - collects metrics
2. victoriametrics - stores metrics
3. grafana - displays metrics
4. pushgateway - receives metrics
5. alertmanager - sends out alerts


## Promethus

The prometheus container will scrape remote targets for metrics and then write
the metrics to victoriametrics database. It talks to victoriametrics by a
network connection on port 8428.

Although prometheus ships with a default (tsdb) database, we use
victoriametrics since it's more efficient.

TODO - explain how to add scrape targets.


## Victoriametrics

A time-series database. It also presents a prometheus-lookalike interface for
use by grafana.


## Grafana

Presents a web interface were one can design dashboards to display
metrics. Usually set up to query prometheus, but we configure it to read
directly from victoriametrics.


## Pushgateway

Prometheus default way of collecting metrics is to pull it from remote targets. Pushgateway instead receives metrics by way of push and sends them on to prometheus.


## Alertmanager

Sends alerts through email, slack etc.
https://prometheus.io/docs/alerting/alertmanager/


Reloading config.
"Alertmanager can reload its configuration at runtime. If the new configuration
is not well-formed, the changes will not be applied and an error is logged. A
configuration reload is triggered by sending a SIGHUP to the process or sending
a HTTP POST request to the /-/reload endpoint."


## References

Example docker-compose files.
https://github.com/vegasbrianc/prometheus/blob/master/docker-compose.yml
https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/deployment/docker


### Victoriametrics configuration

https://github.com/VictoriaMetrics/VictoriaMetrics/wiki/Single-server-VictoriaMetrics


### Prometheus configuration

https://prometheus.io/docs/prometheus/latest/configuration/configuration/
$ docker run --rm -it prom/prometheus --help
