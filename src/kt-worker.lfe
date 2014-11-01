(defmodule kt-worker
  (export all))

(include-lib "kanin/include/amqp-client.lfe")

(defun receive ()
  (let* ((net-opts (kanin-uri:parse "amqp://localhost"))
         (`#(ok ,connection) (kanin-conn:start net-opts))
         (`#(ok ,channel) (kanin-conn:open-channel connection))
         (queue-name "task-queue")
         (queue (make-queue.declare
                  queue (list_to_binary queue-name)
                  durable 'true))
         (qos (make-basic.qos prefetch_count 1))
         (consumer (make-basic.consume
                     queue (list_to_binary queue-name)))
         (subscriber (self)))
    (kanin-chan:call channel queue)
    (io:format "[*] Waiting for messages. To exit press CTRL+C~n")
    (kanin-chan:call channel qos)
    (kanin-chan:subscribe channel consumer subscriber)
    (receive
      ((match-basic.consume_ok)
        'ok))
    (loop channel)))

(defun loop (channel)
  (receive
    ((tuple (match-basic.deliver delivery_tag tag)
            (match-amqp_msg payload body))
      (io:format "[x] Received: ~p~n" `(,body))
      (do-work body)
      (io:format "[x] Done.~n")
      (kanin-chan:cast channel (make-basic.ack delivery_tag tag))
      (loop channel))))

(defun get-dot-count (data)
  (length
    (list-comp
      ((<- char (binary_to_list data)) (== char #\.))
      char)))

(defun do-work (body)
  (let ((dots (get-dot-count body)))
        (receive
          (after (* dots 1000)
            'ok))))
