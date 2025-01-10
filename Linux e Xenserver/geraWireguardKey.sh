#!/bin/bash

wg genkey > privatekey
wg pubkey < privatekey > publickey
wg genkey | tee privatekey | wg pubkey > publickey
