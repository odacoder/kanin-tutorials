(defmodule kt-sending
  (export all))

(include-lib "kanin/include/amqp-client.lfe")

(defun send ()
  (let* ((net-opts (make-amqp_params_network host "localhost"))
         ;; create the connection and channel we'll use for sending
         (`#(ok ,connection) (kanin-conn:start net-opts))
         (`#(ok ,channel) (kanin-conn:open-channel connection))
         ;; declare the names we will use
         (queue-name "hello")
         (routing-key "hello")
         (exchange-name "")
         ;; define the data we will send
         (payload "Hello, world!")
         ;; then create the needed records
         (queue (make-queue.declare
                  queue (list_to_binary queue-name)))
         (method (make-basic.publish
                   exchange (list_to_binary exchange-name)
                   routing_key (list_to_binary routing-key)))
         (message (make-amqp_msg
                    payload (list_to_binary payload))))
    ;; set up the queue
    (kanin-chan:call channel queue)
    ;; perform the actual send
    (kanin-chan:cast channel method message)
    (io:format "[x] Sent message '~p'~n" `(,payload))
    ;; clean up
    (kanin-chan:close channel)
    (kanin-conn:close connection)))
