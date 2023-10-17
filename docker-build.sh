#!/usr/bin/env bash

export BUILDKIT_PROGRESS=plain
docker build --target builder . -t builder
docker build . -t app
