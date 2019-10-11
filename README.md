# Downtime Reporter

## Idea

Checks every minute if a chosen host is available via HTTP. If not it connects to another wifi AP and starts sending reporting messages to a queue.

The queue gets parsed by some other logic to send automated messages about downtime to your ISP.

## Requirements

A Debian buster host with two available APs.

wpa_supplicant

AP 1: Primary network connection
AP 2: Secondary network connection
