# Kanin Tutorial Code

*For the Kanin / RabbitMQ Tutorials*


## Introduction

The "code" in this project is the "answer set" for the
[the Kanin / RabbitMQ tutorials](https://github.com/billosys/kanin/blob/master/doc/tutorials.md).
This is what you get if you following the steps of each tutorial and complete the tasks as instructed.


## Use

For use with the tutorials, do the following:

1. ``$ git clone https://github.com/billosys/kanin-tutorials.git``
1. ``$ cd kanin-tutorial``
1. ``$ make compile``

This step will take a bit longer than most LFE/Erlang ``rebar compile`` steps,
as it will download three dependency RabbitMQ/AMQP libraries and build them
as part of the Kanin dependency chain.

After that, you're ready to use the LFE REPL and following along in the
tutorial:

* ``$ make repl-no-deps``

