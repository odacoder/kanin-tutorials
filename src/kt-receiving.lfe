(defmodule kt-receiving
  (export all))

(include-lib "kanin/include/amqp-client.lfe")

(defun receive ()
  (let* ((net-opts (make-amqp_params_network host "localhost"))
         ;; create the connection and channel we'll use for sending
         (`#(ok ,connection) (kanin-conn:start net-opts))
         (`#(ok ,channel) (kanin-conn:open-channel connection))
         ;; declare the names we will use
         (queue-name "hello")
         ;; define the data we will send
         (payload "Hello, world!")
         ;; then create the needed records
         (queue (make-queue.declare
                  queue (list_to_binary queue-name)))
         (consumer (make-basic.consume
                     queue (list_to_binary queue-name)
                     no_ack 'true))
         (subscriber (self)))
    ;; set up the queue
    (kanin-chan:call channel queue)
    (io:format "[*] Waiting for messages. To exit press CTRL+C~n")
    ;; subscribe the receive funtion to the queue
    (kanin-chan:subscribe channel consumer subscriber)
    ;; verify that the 'receive' function gets a successful result from
    ;; the previous (kanin-chan:subscribe ...) call
    (receive
      ((match-basic.consume_ok)
        'ok))
    ;; start listening for messages
    (loop channel)))

(defun loop (channel)
  ;; listen for a message that is a 2-tuple of two records: a basic.deliver
  ;; one, and an amqp_msg one
  (receive
    ((tuple (match-basic.deliver) (match-amqp_msg payload body))
      (io:format "[x] Received: ~p~n" `(,body))
      ;; restart the loop to listen for the next message
      (loop channel))))
