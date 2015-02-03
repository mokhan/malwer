require 'sneakers/metrics/logging_metrics'

Sneakers.configure({
  metrics: Sneakers::Metrics::LoggingMetrics.new,
})
Sneakers.logger.level = Logger::INFO
