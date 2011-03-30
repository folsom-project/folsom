### folsom

folsom is an Erlang based metrics and event system. The metrics API's purpose is to collect realtime metrics from various systems via REST and Erlang API's. The basic idea is that you create a metric via either API and then alert the metric with new values as you receive them. You can then retrieve information about these metrics, such as a histogram and the mean. The metric data is stored in memory in one of two kinds of samples, uniform and exponentially decaying, "exdec". Optionally you can choose not to sample the data whatsoever. Additionally you can tag you metrics so you can query groups of them.

The other half of folsom is it's event system. This can be used to track events in a system. folsom allows you to create "event handlers" that you can think of them as capped-size ordered buckets of events. Each bucket can be assigned tags upon creation which can be used later to retrieve a group of handlers. Events within these bucks are assigned a time ordered key based on epoch (in microseconds), additionally events can be assigned tags on creation which can be used later to retrieve a group of events.

Lastly, folsom as both erlang and REST API's for Erlang VM statistics.

#### _metrics API Usage

Here are some examples in both HTTP and Erlang.

Create a exdec metric named "a" with a sample size of 5 values, a tag "test" and an alpha of 1:

       > folsom_metrics_event:add_handler(a, exdec, 5, 1).

       $ curl -X PUT http://localhost:5555/_metrics -d '{"id": "a", "size": 5, "type": "exdec", "tags": ["test"], "alpha": 1}' -H 'Content-Type: application/json'

Create a uniform metric named "b" with a sample size of 5 values:

       > folsom_metrics_event:add_handler(b, uniform, 5).

       $ curl -X PUT http://localhost:5555/_metrics -d '{"id": "b", "size": 5, "type": "uniform"}' -H 'Content-Type: application/json'

Create a metric without sampling named "c" with a sample size of 5 values:

       > folsom_metrics_event:add_handler(c, none, 5).

       $ curl -X PUT http://localhost:5555/_metrics -d '{"id": "c", "size": 5, "type": "uniform"}' -H 'Content-Type: application/json'

Query available metrics:

      > folsom_metrics_event:get_handlers().

      $ curl -X GET http://localhost:5555/_metrics

Query available event handlers with additional info:

      > folsom_metrics_event:get_handlers_info().

      $ curl http://localhost:5555/_metrics?info=true

Query a specific metric:

      > folsom_metrics_event:get_statistics(a).

      $ curl -X GET http://localhost:5555/_metrics/a

Query handlers that have a specific tag assigned:

      > folsom_metrics_event:get_tagged_handlers(test).

      $ curl http://localhost:5555/_metrics?tag=test

Query a specific metric for its raw sample:

      > folsom_metrics_event:get_values(a).

      $ curl http://localhost:5555/_metrics/a?raw=true

Query the covariance of two metrics:

      > folsom_statistics:get_covariance(b, a).

      > curl http://localhost:5555/_metrics/b?covariance=a

Notify a metric of an event:

      > folsom_metrics_event:notify({a, 1}).

      $ curl -X PUT http://localhost:5555/_metrics/a -d '{"value": 1}' -H 'Content-Type: application/json'

Delete a metric:

       > folsom_metrics_event:delete_handler(a).

       $ curl -X DELETE http://localhost:5555/_metrics/a

#### _events API Usage

Create a event handler named "d" with a max size of 5 and two tags:

       > folsom_events_event:add_handler(d, [test, blah], 5).

       $ curl -X PUT http://localhost:5555/_events -d '{"id": "d", "size": 5, "tags": ["test", "blah"]}' -H 'Content-Type: application/json'

Query available event handlers:

      > folsom_events_event:get_handlers().

      $ curl http://localhost:5555/_events

Query available event handlers with additional info:

      > folsom_events_event:get_handlers_info().

      $ curl http://localhost:5555/_events?info=true

Query handlers that have a specific tag assigned:

      > folsom_events_event:get_tagged_handlers(test).

      $ curl http://localhost:5555/_events?tag=test

Query a specific event handler for events:

      > folsom_events_event:get_events(d).

      $ curl http://localhost:5555/_events/d

Query a specific event handler for events with a limit:

      > folsom_events_event:get_events(d, 1).

      $ curl http://localhost:5555/_events/d?limit=1

Query a specific event_handler for events with a tag:

      > folsom_events_event:get_events(d, test).

      $ curl http://localhost:5555/_events/d?tag=test

Notify an event handler of an event:

      > folsom_events_event:notify({d, [test], "something"}).

      $ curl -X PUT http://localhost:5555/_events/d -d '{"event": "something", "tags": ["test", "blah"]}' -H 'Content-Type: application/json'

Delete a event handler:

       > folsom_events_event:delete_handler(d).

       $ curl -X DELETE http://localhost:5555/_events/d

#### Erlang VM Metrics:

The result of `erlang:memory/0`:

       > folsom_vm_metrics:get_memory().

       $ curl http://localhost:5555/_memory

The result of `erlang:system_info/1`:

       > folsom_vm_metrics:get_system_info().

       $ curl http://localhost:5555/_system

The result of `erlang:statistics/1`:

       > folsom_vm_metrics:get_statistics().

       $ curl http://localhost:5555/_statistics