(defmodule kt-new-task
  (export all))

(include-lib "kanin/include/amqp-client.lfe")

(defun make-message
  (('())
    "Hello, world!")
  ((data)
    data))

(defun send ()
  (send '()))

(defun send (data)
  (let* ((net-opts (make-amqp_params_network host "localhost"))
         (`#(ok ,connection) (kanin-conn:start net-opts))
         (`#(ok ,channel) (kanin-conn:open-channel connection))
         (queue-name "task-queue")
         (routing-key "task-queue")
         (exchange-name "")
         (payload (make-message data))
         (queue (make-queue.declare
                  queue (list_to_binary queue-name)
                  durable 'true))
         (method (make-basic.publish
                   exchange (list_to_binary exchange-name)
                   routing_key (list_to_binary routing-key)))
         (message (make-amqp_msg
                    props (make-P_basic delivery_mode 2)
                    payload (list_to_binary payload))))
    (kanin-chan:call channel queue)
    (kanin-chan:cast channel method message)
    (io:format "[x] Sent message '~p'~n" `(,payload))
    (kanin-chan:close channel)
    (kanin-conn:close connection)))
